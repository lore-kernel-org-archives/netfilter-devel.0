From: "=?gb2312?B?uN+y/cD7?=" <xiaosuo@mail.nankai.edu.cn>
Subject: [PATCH] ip_conntrack_ftp: enhancement
Date: Mon, 28 May 2007 22:31:38 +0800
Message-ID: <380362698.00579@mail.nankai.edu.cn>
Reply-To: =?gb2312?B?uN+y/cD7?= <xiaosuo@mail.nankai.edu.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_1180362698_547.attach"
Cc: xiaosuo@gmail.com
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

------=_1180362698_547.attach
Content-Type: text/plain

[NETFILTER]: nf_conntrack_ftp: Enhance the support to ftp and security.

Includes:
1. Command terminated with LF instead of CRLF.
2. More spaces exists between command and arguments.
3. Multi-commands in one packets.

Explains:
to 1: Though rfc959 doesn't think LF is valid terminator, there are
many ftp servers and clients support it. In fact, it is a real
standard. As it isn't very difficult to implement it. So I did it.
to 2: It is in rfc959. "The command codes and the argument fields are
separated by one or more spaces."(section 5.3)
to 3: You can't prevent the transfer layer or a user to do that.

Beside of these, I also make a stricter police: all the packets which
don't recognized properly aren't allow to pass the firewall. I assume
that the ftp command packets should be started after a new line and
they are must terminated by LF or CRLF. If not, they are considered to
be invalid, and will be dropped silently. I think it is better than
passing them, because of a relative security hole mentioned in
phrack63-0x13[http://www.phreakmail.com/phrack63-19.html].

Perhaps you will worry about the packets dropped. It is not a real problem:
1. A normal programmer won't send a command by calling
send/sendto/write more than once.
2. The dropped data will be sent again by transfer layer TCP.
3. The data after the packets dropped won't pass the firewall until
the packets dropped former passed at last. So SACK option of TCP isn't
a problem too.

----
Signed-off-by: xiaosuo <xiaosuo@gmail.com>
----
 ip_conntrack_ftp.c |   94 +++++++++++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 42 deletions(-)
----
--- linux/net/ipv4/netfilter/ip_conntrack_ftp.c 2007-05-28 21:59:22.000000000
+0800
+++ linux-new/net/ipv4/netfilter/ip_conntrack_ftp.c     2007-05-28
22:03:40.000000000 +0800
@@ -105,9 +105,9 @@
                else if (*data == sep)
                        i++;
                else {
-                       /* Unexpected character; true if it's the
-                          terminator and we're finished. */
-                       if (*data == term && i == array_size - 1)
+                       /* Unexpected character; true if it's the terminator or
'\n'
+                        * and we're finished. */
+                       if ((*data == term || *data == '\n') && i == array_size -
1)
                                return len;

                        DEBUGP("Char %u (got %u nums) `%u' unexpected\n",
@@ -205,16 +205,9 @@
        size_t i;

        DEBUGP("find_pattern `%s': dlen = %u\n", pattern, dlen);
-       if (dlen == 0)
+       if (dlen == 0 || dlen <= plen)
                return 0;

-       if (dlen <= plen) {
-               /* Short packet: try for partial? */
-               if (strnicmp(data, pattern, dlen) == 0)
-                       return -1;
-               else return 0;
-       }
-
        if (strnicmp(data, pattern, plen) != 0) {
 #if 0
                size_t i;
@@ -235,8 +228,10 @@
        for (i = plen; data[i] != skip; i++)
                if (i == dlen - 1) return -1;

-       /* Skip over the last character */
-       i++;
+       /* rfc959: The command codes and the argument fields are
+        * separated by one or more spaces.*/
+       for (; data[i] == skip; i ++)
+               if (i == dlen - 1) return -1;

        DEBUGP("Skipped up to `%c'!\n", skip);

@@ -291,15 +286,15 @@
 {
        unsigned int dataoff, datalen;
        struct tcphdr _tcph, *th;
-       char *fb_ptr;
+       char *fb_ptr, *ptr;
        int ret;
        u32 seq, array[6] = { 0 };
        int dir = CTINFO2DIR(ctinfo);
        unsigned int matchlen, matchoff;
        struct ip_ct_ftp_master *ct_ftp_info = &ct->help.ct_ftp_info;
        struct ip_conntrack_expect *exp;
-       unsigned int i;
-       int found = 0, ends_in_nl;
+       unsigned int i, i_old;
+       int found = 0, found_old = 0;

        /* Until there's been traffic both ways, don't look in packets. */
        if (ctinfo != IP_CT_ESTABLISHED
@@ -326,18 +321,20 @@
                                    (*pskb)->len - dataoff, ftp_buffer);
        BUG_ON(fb_ptr == NULL);

-       ends_in_nl = (fb_ptr[datalen - 1] == '\n');
-       seq = ntohl(th->seq) + datalen;
-
-       /* Look up to see if we're just after a \n. */
-       if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
-               /* Now if this ends in \n, update ftp info. */
-               DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u) or %s(%u)\n",
-                      ct_ftp_info->seq_aft_nl[0][dir]
-                      old_seq_aft_nl_set ? "":"(UNSET) ", old_seq_aft_nl);
-               ret = NF_ACCEPT;
-               goto out_update_nl;
+        /* We don't allow such a command or reply splitted into
+        * multi-packages. */
+       if (fb_ptr[datalen - 1] != '\n') {
+               ret = NF_DROP;
+               goto out;
+       }
+       seq = ntohl(th->seq);
+       if (ct_ftp_info->seq_aft_nl_num[dir] == 0) {
+               update_nl_seq(seq, ct_ftp_info, dir, *pskb);
+       } else if (!find_nl_seq(seq, ct_ftp_info, dir)) {
+               ret = NF_DROP;
+               goto out;
        }
+       seq += datalen;

        /* Initialize IP array to expected address (it's not mentioned
            in EPSV responses) */
@@ -346,10 +343,11 @@
        array[2] = (ntohl(ct->tuplehash[dir].tuple.src.ip) >> 8) & 0xFF;
        array[3] = ntohl(ct->tuplehash[dir].tuple.src.ip) & 0xFF;

+again:
        for (i = 0; i < ARRAY_SIZE(search); i++) {
                if (search[i].dir != dir) continue;

-               found = find_pattern(fb_ptr, (*pskb)->len - dataoff,
+               found = find_pattern(fb_ptr, datalen,
                                     search[i].pattern,
                                     search[i].plen,
                                     search[i].skip,
@@ -360,19 +358,32 @@
                if (found) break;
        }
        if (found == -1) {
-               /* We don't usually drop packets.  After all, this is
-                  connection tracking, not packet filtering.
-                  However, it is necessary for accurate tracking in
-                  this case. */
-               if (net_ratelimit())
-                       printk("conntrack_ftp: partial %s %u+%u\n",
-                              search[i].pattern,
-                              ntohl(th->seq), datalen);
+               /* In order to prevent a kind of attrack based
+                * on non-tracked sub-connection[phrack63_0x13].
+                * We will drop it instead of accepting it. */
                ret = NF_DROP;
                goto out;
-       } else if (found == 0) { /* No match */
-               ret = NF_ACCEPT;
-               goto out_update_nl;
+       }
+
+       /* Is there another line nested? */
+       ptr = memchr(fb_ptr, '\n', datalen);
+       if (ptr != NULL && ptr != &fb_ptr[datalen - 1]) {
+               datalen -= ++ptr - fb_ptr;
+               fb_ptr = ptr;
+               if (found) {
+                       found_old = found;
+                       i_old = i;
+               }
+               goto again;
+       }
+
+       if (found == 0) {
+               if (found_old == 0) { /* No match */
+                       ret = NF_ACCEPT;
+                       goto out_update_nl;
+               }
+               found = found_old;
+               i = i_old;
        }

        DEBUGP("conntrack_ftp: match `%s' (%u bytes at %u)\n",
@@ -442,9 +453,8 @@
 out_update_nl:
        /* Now if this ends in \n, update ftp info.  Seq may have been
         * adjusted by NAT code. */
-       if (ends_in_nl)
-               update_nl_seq(seq, ct_ftp_info,dir, *pskb);
- out:
+       update_nl_seq(seq, ct_ftp_info, dir, *pskb);
+out:
        spin_unlock_bh(&ip_ftp_lock);
        return ret;
 }



------=_1180362698_547.attach
Content-Type: application/octet-stream; name="ip_conntrack_ftp-enhanced.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="ip_conntrack_ftp-enhanced.patch"

LS0tIGxpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfZnRwLmMJMjAwNy0w
NS0yOCAyMTo1OToyMi4wMDAwMDAwMDAgKzA4MDAKKysrIGxpbnV4LW5ldy9uZXQvaXB2NC9u
ZXRmaWx0ZXIvaXBfY29ubnRyYWNrX2Z0cC5jCTIwMDctMDUtMjggMjI6MDM6NDAuMDAwMDAw
MDAwICswODAwCkBAIC0xMDUsOSArMTA1LDkgQEAKIAkJZWxzZSBpZiAoKmRhdGEgPT0gc2Vw
KQogCQkJaSsrOwogCQllbHNlIHsKLQkJCS8qIFVuZXhwZWN0ZWQgY2hhcmFjdGVyOyB0cnVl
IGlmIGl0J3MgdGhlCi0JCQkgICB0ZXJtaW5hdG9yIGFuZCB3ZSdyZSBmaW5pc2hlZC4gKi8K
LQkJCWlmICgqZGF0YSA9PSB0ZXJtICYmIGkgPT0gYXJyYXlfc2l6ZSAtIDEpCisJCQkvKiBV
bmV4cGVjdGVkIGNoYXJhY3RlcjsgdHJ1ZSBpZiBpdCdzIHRoZSB0ZXJtaW5hdG9yIG9yICdc
bicKKwkJCSAqIGFuZCB3ZSdyZSBmaW5pc2hlZC4gKi8KKwkJCWlmICgoKmRhdGEgPT0gdGVy
bSB8fCAqZGF0YSA9PSAnXG4nKSAmJiBpID09IGFycmF5X3NpemUgLSAxKQogCQkJCXJldHVy
biBsZW47CiAKIAkJCURFQlVHUCgiQ2hhciAldSAoZ290ICV1IG51bXMpIGAldScgdW5leHBl
Y3RlZFxuIiwKQEAgLTIwNSwxNiArMjA1LDkgQEAKIAlzaXplX3QgaTsKIAogCURFQlVHUCgi
ZmluZF9wYXR0ZXJuIGAlcyc6IGRsZW4gPSAldVxuIiwgcGF0dGVybiwgZGxlbik7Ci0JaWYg
KGRsZW4gPT0gMCkKKwlpZiAoZGxlbiA9PSAwIHx8IGRsZW4gPD0gcGxlbikKIAkJcmV0dXJu
IDA7CiAKLQlpZiAoZGxlbiA8PSBwbGVuKSB7Ci0JCS8qIFNob3J0IHBhY2tldDogdHJ5IGZv
ciBwYXJ0aWFsPyAqLwotCQlpZiAoc3RybmljbXAoZGF0YSwgcGF0dGVybiwgZGxlbikgPT0g
MCkKLQkJCXJldHVybiAtMTsKLQkJZWxzZSByZXR1cm4gMDsKLQl9Ci0KIAlpZiAoc3Rybmlj
bXAoZGF0YSwgcGF0dGVybiwgcGxlbikgIT0gMCkgewogI2lmIDAKIAkJc2l6ZV90IGk7CkBA
IC0yMzUsOCArMjI4LDEwIEBACiAJZm9yIChpID0gcGxlbjsgZGF0YVtpXSAhPSBza2lwOyBp
KyspCiAJCWlmIChpID09IGRsZW4gLSAxKSByZXR1cm4gLTE7CiAKLQkvKiBTa2lwIG92ZXIg
dGhlIGxhc3QgY2hhcmFjdGVyICovCi0JaSsrOworCS8qIHJmYzk1OTogVGhlIGNvbW1hbmQg
Y29kZXMgYW5kIHRoZSBhcmd1bWVudCBmaWVsZHMgYXJlCisJICogc2VwYXJhdGVkIGJ5IG9u
ZSBvciBtb3JlIHNwYWNlcy4qLworCWZvciAoOyBkYXRhW2ldID09IHNraXA7IGkgKyspCisJ
CWlmIChpID09IGRsZW4gLSAxKSByZXR1cm4gLTE7CiAKIAlERUJVR1AoIlNraXBwZWQgdXAg
dG8gYCVjJyFcbiIsIHNraXApOwogCkBAIC0yOTEsMTUgKzI4NiwxNSBAQAogewogCXVuc2ln
bmVkIGludCBkYXRhb2ZmLCBkYXRhbGVuOwogCXN0cnVjdCB0Y3BoZHIgX3RjcGgsICp0aDsK
LQljaGFyICpmYl9wdHI7CisJY2hhciAqZmJfcHRyLCAqcHRyOwogCWludCByZXQ7CiAJdTMy
IHNlcSwgYXJyYXlbNl0gPSB7IDAgfTsKIAlpbnQgZGlyID0gQ1RJTkZPMkRJUihjdGluZm8p
OwogCXVuc2lnbmVkIGludCBtYXRjaGxlbiwgbWF0Y2hvZmY7CiAJc3RydWN0IGlwX2N0X2Z0
cF9tYXN0ZXIgKmN0X2Z0cF9pbmZvID0gJmN0LT5oZWxwLmN0X2Z0cF9pbmZvOwogCXN0cnVj
dCBpcF9jb25udHJhY2tfZXhwZWN0ICpleHA7Ci0JdW5zaWduZWQgaW50IGk7Ci0JaW50IGZv
dW5kID0gMCwgZW5kc19pbl9ubDsKKwl1bnNpZ25lZCBpbnQgaSwgaV9vbGQ7CisJaW50IGZv
dW5kID0gMCwgZm91bmRfb2xkID0gMDsKIAogCS8qIFVudGlsIHRoZXJlJ3MgYmVlbiB0cmFm
ZmljIGJvdGggd2F5cywgZG9uJ3QgbG9vayBpbiBwYWNrZXRzLiAqLwogCWlmIChjdGluZm8g
IT0gSVBfQ1RfRVNUQUJMSVNIRUQKQEAgLTMyNiwxOCArMzIxLDIwIEBACiAJCQkJICAgICgq
cHNrYiktPmxlbiAtIGRhdGFvZmYsIGZ0cF9idWZmZXIpOwogCUJVR19PTihmYl9wdHIgPT0g
TlVMTCk7CiAKLQllbmRzX2luX25sID0gKGZiX3B0cltkYXRhbGVuIC0gMV0gPT0gJ1xuJyk7
Ci0Jc2VxID0gbnRvaGwodGgtPnNlcSkgKyBkYXRhbGVuOwotCi0JLyogTG9vayB1cCB0byBz
ZWUgaWYgd2UncmUganVzdCBhZnRlciBhIFxuLiAqLwotCWlmICghZmluZF9ubF9zZXEobnRv
aGwodGgtPnNlcSksIGN0X2Z0cF9pbmZvLCBkaXIpKSB7Ci0JCS8qIE5vdyBpZiB0aGlzIGVu
ZHMgaW4gXG4sIHVwZGF0ZSBmdHAgaW5mby4gKi8KLQkJREVCVUdQKCJpcF9jb25udHJhY2tf
ZnRwX2hlbHA6IHdyb25nIHNlcSBwb3MgJXMoJXUpIG9yICVzKCV1KVxuIiwKLQkJICAgICAg
IGN0X2Z0cF9pbmZvLT5zZXFfYWZ0X25sWzBdW2Rpcl0gCi0JCSAgICAgICBvbGRfc2VxX2Fm
dF9ubF9zZXQgPyAiIjoiKFVOU0VUKSAiLCBvbGRfc2VxX2FmdF9ubCk7Ci0JCXJldCA9IE5G
X0FDQ0VQVDsKLQkJZ290byBvdXRfdXBkYXRlX25sOworCSAvKiBXZSBkb24ndCBhbGxvdyBz
dWNoIGEgY29tbWFuZCBvciByZXBseSBzcGxpdHRlZCBpbnRvCisJICogbXVsdGktcGFja2Fn
ZXMuICovCisJaWYgKGZiX3B0cltkYXRhbGVuIC0gMV0gIT0gJ1xuJykgeworCQlyZXQgPSBO
Rl9EUk9QOworCQlnb3RvIG91dDsKKwl9CisJc2VxID0gbnRvaGwodGgtPnNlcSk7CisJaWYg
KGN0X2Z0cF9pbmZvLT5zZXFfYWZ0X25sX251bVtkaXJdID09IDApIHsKKwkJdXBkYXRlX25s
X3NlcShzZXEsIGN0X2Z0cF9pbmZvLCBkaXIsICpwc2tiKTsKKwl9IGVsc2UgaWYgKCFmaW5k
X25sX3NlcShzZXEsIGN0X2Z0cF9pbmZvLCBkaXIpKSB7CisJCXJldCA9IE5GX0RST1A7CisJ
CWdvdG8gb3V0OwogCX0KKwlzZXEgKz0gZGF0YWxlbjsKIAogCS8qIEluaXRpYWxpemUgSVAg
YXJyYXkgdG8gZXhwZWN0ZWQgYWRkcmVzcyAoaXQncyBub3QgbWVudGlvbmVkCiAgICAgICAg
ICAgIGluIEVQU1YgcmVzcG9uc2VzKSAqLwpAQCAtMzQ2LDEwICszNDMsMTEgQEAKIAlhcnJh
eVsyXSA9IChudG9obChjdC0+dHVwbGVoYXNoW2Rpcl0udHVwbGUuc3JjLmlwKSA+PiA4KSAm
IDB4RkY7CiAJYXJyYXlbM10gPSBudG9obChjdC0+dHVwbGVoYXNoW2Rpcl0udHVwbGUuc3Jj
LmlwKSAmIDB4RkY7CiAKK2FnYWluOgogCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHNl
YXJjaCk7IGkrKykgewogCQlpZiAoc2VhcmNoW2ldLmRpciAhPSBkaXIpIGNvbnRpbnVlOwog
Ci0JCWZvdW5kID0gZmluZF9wYXR0ZXJuKGZiX3B0ciwgKCpwc2tiKS0+bGVuIC0gZGF0YW9m
ZiwKKwkJZm91bmQgPSBmaW5kX3BhdHRlcm4oZmJfcHRyLCBkYXRhbGVuLAogCQkJCSAgICAg
c2VhcmNoW2ldLnBhdHRlcm4sCiAJCQkJICAgICBzZWFyY2hbaV0ucGxlbiwKIAkJCQkgICAg
IHNlYXJjaFtpXS5za2lwLApAQCAtMzYwLDE5ICszNTgsMzIgQEAKIAkJaWYgKGZvdW5kKSBi
cmVhazsKIAl9CiAJaWYgKGZvdW5kID09IC0xKSB7Ci0JCS8qIFdlIGRvbid0IHVzdWFsbHkg
ZHJvcCBwYWNrZXRzLiAgQWZ0ZXIgYWxsLCB0aGlzIGlzCi0JCSAgIGNvbm5lY3Rpb24gdHJh
Y2tpbmcsIG5vdCBwYWNrZXQgZmlsdGVyaW5nLgotCQkgICBIb3dldmVyLCBpdCBpcyBuZWNl
c3NhcnkgZm9yIGFjY3VyYXRlIHRyYWNraW5nIGluCi0JCSAgIHRoaXMgY2FzZS4gKi8KLQkJ
aWYgKG5ldF9yYXRlbGltaXQoKSkKLQkJCXByaW50aygiY29ubnRyYWNrX2Z0cDogcGFydGlh
bCAlcyAldSsldVxuIiwKLQkJCSAgICAgICBzZWFyY2hbaV0ucGF0dGVybiwKLQkJCSAgICAg
ICBudG9obCh0aC0+c2VxKSwgZGF0YWxlbik7CisJCS8qIEluIG9yZGVyIHRvIHByZXZlbnQg
YSBraW5kIG9mIGF0dHJhY2sgYmFzZWQKKwkJICogb24gbm9uLXRyYWNrZWQgc3ViLWNvbm5l
Y3Rpb25bcGhyYWNrNjNfMHgxM10uCisJCSAqIFdlIHdpbGwgZHJvcCBpdCBpbnN0ZWFkIG9m
IGFjY2VwdGluZyBpdC4gKi8KIAkJcmV0ID0gTkZfRFJPUDsKIAkJZ290byBvdXQ7Ci0JfSBl
bHNlIGlmIChmb3VuZCA9PSAwKSB7IC8qIE5vIG1hdGNoICovCi0JCXJldCA9IE5GX0FDQ0VQ
VDsKLQkJZ290byBvdXRfdXBkYXRlX25sOworCX0KKwkKKwkvKiBJcyB0aGVyZSBhbm90aGVy
IGxpbmUgbmVzdGVkPyAqLworCXB0ciA9IG1lbWNocihmYl9wdHIsICdcbicsIGRhdGFsZW4p
OworCWlmIChwdHIgIT0gTlVMTCAmJiBwdHIgIT0gJmZiX3B0cltkYXRhbGVuIC0gMV0pIHsK
KwkJZGF0YWxlbiAtPSArK3B0ciAtIGZiX3B0cjsKKwkJZmJfcHRyID0gcHRyOworCQlpZiAo
Zm91bmQpIHsKKwkJCWZvdW5kX29sZCA9IGZvdW5kOworCQkJaV9vbGQgPSBpOworCQl9CisJ
CWdvdG8gYWdhaW47CisJfQorCisJaWYgKGZvdW5kID09IDApIHsKKwkJaWYgKGZvdW5kX29s
ZCA9PSAwKSB7IC8qIE5vIG1hdGNoICovCisJCQlyZXQgPSBORl9BQ0NFUFQ7CisJCQlnb3Rv
IG91dF91cGRhdGVfbmw7CisJCX0KKwkJZm91bmQgPSBmb3VuZF9vbGQ7CisJCWkgPSBpX29s
ZDsKIAl9CiAKIAlERUJVR1AoImNvbm50cmFja19mdHA6IG1hdGNoIGAlcycgKCV1IGJ5dGVz
IGF0ICV1KVxuIiwKQEAgLTQ0Miw5ICs0NTMsOCBAQAogb3V0X3VwZGF0ZV9ubDoKIAkvKiBO
b3cgaWYgdGhpcyBlbmRzIGluIFxuLCB1cGRhdGUgZnRwIGluZm8uICBTZXEgbWF5IGhhdmUg
YmVlbgogCSAqIGFkanVzdGVkIGJ5IE5BVCBjb2RlLiAqLwotCWlmIChlbmRzX2luX25sKQot
CQl1cGRhdGVfbmxfc2VxKHNlcSwgY3RfZnRwX2luZm8sZGlyLCAqcHNrYik7Ci0gb3V0Ogor
CXVwZGF0ZV9ubF9zZXEoc2VxLCBjdF9mdHBfaW5mbywgZGlyLCAqcHNrYik7CitvdXQ6CiAJ
c3Bpbl91bmxvY2tfYmgoJmlwX2Z0cF9sb2NrKTsKIAlyZXR1cm4gcmV0OwogfQo=

------=_1180362698_547.attach--
