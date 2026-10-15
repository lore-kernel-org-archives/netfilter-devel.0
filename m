Received: from smtp.ideco.ru (smtp.ideco.ru [51.250.56.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557BC48B383
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 06:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.250.56.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792047231; cv=none; b=VRJDX8l/kW/uY/Chzu5IwJBTnJFxvspCTbGn76bq0dyWYk/0E7PnT3F1TBHfYvXk+TooIfskC4dDjCWtVOhqRZuiB/y76hgI9vRVPZctmszrcnL7n0pwc3idpaqTrei+cg8QKJsVNVTGTAkqAf+Rgs11wKlF4Igjlzg1w+mapDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792047231; c=relaxed/simple;
	bh=3BJ/xpFg8wehOxNbA2GHDy0mH9lAvotxINILf3oBH+Y=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:From:Subject; b=u+Ii0cZqEq22OuhjG42qxKNp1vXQoGT1D+lWCzZ3wzd7ztQqYA+t0NWpIqeL2/IIyeI4x+zP6wQXe3SZ8jHS5KngQp/8Ve9u0spJKNqQDy0brdbCzhPNok80iP5ZyLVPwoiL2kFAyd5Ct1Pm9PRhxr8+cdgy/yAoG8/tL2KR5uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru; spf=pass smtp.mailfrom=ideco.ru; dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b=HEkkV1JG; arc=none smtp.client-ip=51.250.56.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideco.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideco.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ideco.ru header.i=@ideco.ru header.b="HEkkV1JG"
Received: from [169.254.254.254] (localhost [127.0.0.1])
	by smtp.ideco.ru (Postfix) with ESMTP id 354602038AD2
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 11:43:37 +0500 (+05)
Received: from [192.168.1.125] (unknown [5.189.69.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.ideco.ru (Postfix) with ESMTPSA id 040F720313B8
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 11:43:34 +0500 (+05)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.ideco.ru 040F720313B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ideco.ru; s=ics;
	t=1792046616; bh=3BJ/xpFg8wehOxNbA2GHDy0mH9lAvotxINILf3oBH+Y=;
	h=Date:To:From:Subject;
	b=HEkkV1JGY8jUB49YZGiQVSjDLdghGM6WkRjMWG2PL2mTtXViobwC1dn+/3FiXK7/C
	 O9PI3aFnz/XC7FA2ZhPJebLTpixLKFvo1lZCS3bZWgynyBueNOMYMpITec6iNRmHtl
	 Eumgme4QZm7BOwLu3AXtrFPDeuUg6p32bk8uDJwBYajX0it7+Dh8d7RPp+GZvrf0mX
	 Dc6i1VZkCq7kQ+F36lgb2mhdp/bVJH0pmcGD735KOBkVlpe8bX6JvBbyv74UqClkWH
	 TCPcCj1YJqX50RhdJP22Bgg6Earc/VRSMxR7P89cpO1nvIH8z99HHu++ikH+EvdjJc
	 jlBpOaq3ebY+g==
Content-Type: multipart/mixed; boundary="------------G1DkcpEu02H00sW6kC1EwBQZ"
Message-ID: <d32c43b5-09bc-49a5-a366-c3fe10f0c6ca@ideco.ru>
Date: Thu, 15 Oct 2026 11:43:17 +0500
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: netfilter-devel@vger.kernel.org
Content-Language: en-US
From: =?UTF-8?B?0JDRgNGC0LXQvCDQqdC10LvQutGD0L3QvtCy?=
 <a.shchelkunov@ideco.ru>
Subject: [RFC conntrack-tools] conntrackd: StartupResync and the FTFW HELLO
 exchange

This is a multi-part message in MIME format.
--------------G1DkcpEu02H00sW6kC1EwBQZ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

We observed missing initial state synchronization with conntrackd using
FTFW over UDP, StartupResync On, and no PollSecs. I would like to check the
intended behavior before submitting a formal patch.

Versions and scope
------------------
We reproduced the behavior with downstream builds of conntrack-tools
1.4.7 and 1.4.9. The upstream 1.4.7 and 1.4.9 versions of
src/sync-ftfw.c and src/resync.c are identical. We have not tested current
upstream Git HEAD.

Reproducer
----------
Use two isolated network namespaces, A and R, connected by a veth pair:
A has cta, 198.18.62.1/30; R has ctb, 198.18.62.2/30. Bring both veth
interfaces and both loopback interfaces up. These are test namespaces;
the commands below run inside the indicated namespace.

Use the following configuration for A (/tmp/ftfw-A.conf):

     Sync {
         Mode FTFW { StartupResync On }
         UDP {
             IPv4_address 198.18.62.1
             IPv4_Destination_Address 198.18.62.2
             Interface cta
             Port 3789
         }
     }
     General {
         HashSize 32768
         HashLimit 131072
         NetlinkEventsReliable on
         LockFile /tmp/ftfw-A.lock
         UNIX { Path /tmp/ftfw-A.ctl }
     }

For R, save /tmp/ftfw-R.conf with the two IP addresses swapped, Interface
ctb, LockFile /tmp/ftfw-R.lock, and UNIX Path /tmp/ftfw-R.ctl. Keep both
internal and external caches enabled. Neither configuration has PollSecs.

1. With both conntrackd processes stopped, insert a synthetic entry into
    A's kernel conntrack table:

        conntrack -I -p tcp -s 192.0.2.62 -d 203.0.113.62 \
            --sport 61000 --dport 443 --state ESTABLISHED \
            -u ASSURED,SEEN_REPLY -t 900

2. Start conntrackd in R first:

        conntrackd -C /tmp/ftfw-R.conf

3. After three seconds, start conntrackd in A:

        conntrackd -C /tmp/ftfw-A.conf

4. After ten seconds, inspect A's internal cache and R's external cache
    from separate shells in their respective namespaces:

        # A:
        conntrackd -C /tmp/ftfw-A.conf -i
        # R:
        conntrackd -C /tmp/ftfw-R.conf -e

    With 1.4.9, A has the synthetic entry, but R's external cache is empty.
    No application traffic updates the synthetic entry during this test.

In a separate two-node test with 1.4.7 and ten pre-existing entries, we
observed A internal = 10, R external = 0. A manual request on R:

     conntrackd -C /tmp/ftfw-R.conf -n

recovered all ten entries. With the attached change, both startup tests
synchronized automatically.

Source analysis and the intended semantics
-----------------------------------------
resync_at_startup() immediately queues NET_F_RESYNC. If R starts while A
is absent, that request cannot be delivered. When A starts, its HELLO
causes ftfw_recv() to flush rs_queue. This removes R's pending request
from the resend queue. A requests R's table at its own startup, but this
does not send A's pre-existing kernel entries to R. A's initial kernel
dump populates its internal cache without sending those entries.

The documented StartupResync behavior says "A single request will be
made" and describes synchronization with a peer that was already running.
I therefore do not want to assume that this startup ordering violates
the documented contract, or that reliable FTFW delivery applies during
the HELLO exchange.

Would it be appropriate to keep the startup request pending until the
HELLO exchange completes, so that the request is sent when it can be
handled by the peer?

The attached discussion patch contains two related changes:

1. Defer FTFW's initial automatic RESYNC until the local HELLO state is
    HELLO_DONE and an accepted packet without HELLO arrives from the peer.
2. Re-arm that pending request on a peer HELLO when StartupResync is on.

The second change also recovers entries created in A's kernel while A's
conntrackd was stopped. In our 1.4.7 test, restarting A left R with 10 of
A's 20 entries until R issued a manual request; the patch recovered all
20 automatically. I consider this second change a policy extension:
StartupResync currently does not promise resynchronization on peer
restart. Should it be separate, or controlled by a separate option?

Validation and limitations
--------------------------
The patch passed our isolated 1.4.9 checks for R-first startup, A-first
startup, restart of either daemon, and loss of initial sync packets.
This is not a test against current upstream HEAD or a large-table
performance evaluation.

It adds no periodic full-table request, but repeated HELLO exchanges can
cause extra bulk transfers. The change is gated by StartupResync; the
NOTRACK startup path is unchanged.

The attachment is a source-only discussion diff against 1.4.9, with the
same executable changes as our tested downstream patch. We can split
the two behaviors and update the documentation following your guidance.

Thanks,
Artem

--------------G1DkcpEu02H00sW6kC1EwBQZ
Content-Type: text/x-patch; charset=UTF-8;
 name="ftfw-startup-resync-rfc.patch"
Content-Disposition: attachment; filename="ftfw-startup-resync-rfc.patch"
Content-Transfer-Encoding: base64

UkZDOiBjb25udHJhY2tkOiBkZWZlciBGVEZXIFN0YXJ0dXBSZXN5bmMgdW50aWwgdGhlIEhF
TExPIGV4Y2hhbmdlIGNvbXBsZXRlcwoKQSBzdGFydHVwIFJFU1lOQyBjYW4gYmUgc2VudCB3
aGlsZSB0aGUgcGVlciBpcyBhYnNlbnQgYW5kIHN1YnNlcXVlbnRseQpyZW1vdmVkIGZyb20g
dGhlIHJlc2VuZCBxdWV1ZSB3aGVuIHRoZSBwZWVyIHNlbmRzIEhFTExPLiBLZWVwIHRoZSBu
ZWVkCmZvciByZXN5bmNocm9uaXphdGlvbiBzZXBhcmF0ZWx5IGFuZCBpc3N1ZSBSRVNZTkMg
YWZ0ZXIgSEVMTE8gY29tcGxldGVzLgoKVGhpcyBkaXNjdXNzaW9uIHBhdGNoIGFsc28gcmUt
YXJtcyB0aGUgcmVxdWVzdCBvbiBwZWVyIEhFTExPIHdoaWxlClN0YXJ0dXBSZXN5bmMgaXMg
ZW5hYmxlZC4gUmVzeW5jaHJvbml6aW5nIG9uIHBlZXIgcmVzdGFydCBpcyBhIHBvbGljeQpl
eHRlbnNpb24gYmV5b25kIHRoZSBkb2N1bWVudGVkIG9uZS1zaG90IHN0YXJ0dXAgYmVoYXZp
b3IgYW5kIGlzIHJhaXNlZApzZXBhcmF0ZWx5IGluIHRoZSBhY2NvbXBhbnlpbmcgZW1haWwu
IFJlcGVhdGVkIEhFTExPIGV4Y2hhbmdlcyBjYW4gY2F1c2UKYWRkaXRpb25hbCBidWxrIHRy
YW5zZmVycy4gTm8gcGVyaW9kaWMgZnVsbC10YWJsZSByZXF1ZXN0IGlzIGFkZGVkLgoKQmFz
ZWQgb24gY29ubnRyYWNrLXRvb2xzIDEuNC45LiBFeGVjdXRhYmxlIGNoYW5nZXMgbWF0Y2gg
dGhlIHRlc3RlZApkb3duc3RyZWFtIHBhdGNoOyBjb21tZW50cyBhbmQgdGhpcyBkZXNjcmlw
dGlvbiBoYXZlIGJlZW4gdHJhbnNsYXRlZC4KCmRpZmYgLS1naXQgYS9zcmMvc3luYy1mdGZ3
LmMgYi9zcmMvc3luYy1mdGZ3LmMKLS0tIGEvc3JjL3N5bmMtZnRmdy5jCisrKyBiL3NyYy9z
eW5jLWZ0ZncuYwpAQCAtNTEsNiArNTEsNyBAQAogfTsKIHN0YXRpYyBpbnQgaGVsbG9fc3Rh
dGUgPSBIRUxMT19JTklUOwogc3RhdGljIGludCBzYXlfaGVsbG9fYmFjazsKK3N0YXRpYyBp
bnQgcmVzeW5jX3BlbmRpbmc7CiAKIC8qIFhYWDogYWxpdmUgbWVzc2FnZSBleHBpcmF0aW9u
IGNvbmZpZ3VyYWJsZSAqLwogI2RlZmluZSBBTElWRV9JTlQgMQpAQCAtMTI1LDYgKzEyNiw3
IEBACiAKIAkvKiBzZXQgYWNrIHdpbmRvdyBzaXplICovCiAJd2luZG93ID0gQ09ORklHKHdp
bmRvd19zaXplKTsKKwlyZXN5bmNfcGVuZGluZyA9IENPTkZJRyhzdGFydHVwX3Jlc3luYyk7
CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTMyOCw2ICszMzAsOSBAQAogCiAJaWYgKElTX0hFTExP
KG5ldCkpIHsKIAkJc2F5X2hlbGxvX2JhY2sgPSAxOworCQkvKiBLZWVwIHRoZSByZXN5bmMg
cmVxdWVzdCBhY3Jvc3MgdGhlIEhFTExPIHF1ZXVlIGZsdXNoLiAqLworCQlpZiAoQ09ORklH
KHN0YXJ0dXBfcmVzeW5jKSkKKwkJCXJlc3luY19wZW5kaW5nID0gMTsKIAkJcmV0ID0gMTsK
IAl9CiAJaWYgKElTX0hFTExPX0JBQ0sobmV0KSkgewpAQCAtNDA4LDggKzQxMywxNSBAQAog
CX0KIAogb3V0OgotCWlmICgocmV0ID09IE1TR19EQVRBIHx8IHJldCA9PSBNU0dfQ1RMKSkK
KwlpZiAoKHJldCA9PSBNU0dfREFUQSB8fCByZXQgPT0gTVNHX0NUTCkpIHsKIAkJbmV0aGRy
X3RyYWNrX3VwZGF0ZV9zZXEobmV0LT5zZXEpOworCQkvKiBXYWl0IGZvciB0aGUgcGVlciB0
byBsZWF2ZSBpdHMgSEVMTE8gcGhhc2UuICovCisJCWlmIChyZXN5bmNfcGVuZGluZyAmJiBo
ZWxsb19zdGF0ZSA9PSBIRUxMT19ET05FICYmCisJCSAgICAhSVNfSEVMTE8obmV0KSkgewor
CQkJcmVzeW5jX3BlbmRpbmcgPSAwOworCQkJcmVzeW5jX3JlcSgpOworCQl9CisJfQogCiAJ
cmV0dXJuIHJldDsKIH0KZGlmZiAtLWdpdCBhL3NyYy9yZXN5bmMuYyBiL3NyYy9yZXN5bmMu
YwotLS0gYS9zcmMvcmVzeW5jLmMKKysrIGIvc3JjL3Jlc3luYy5jCkBAIC00NCw1ICs0NCw5
IEBACiAJaWYgKENPTkZJRyhzdGFydHVwX3Jlc3luYykgPT0gMCkKIAkJcmV0dXJuOwogCisJ
LyogRlRGVyByZXF1ZXN0cyBhIHJlc3luYyBhZnRlciBjb21wbGV0aW5nIHRoZSBIRUxMTyBl
eGNoYW5nZS4gKi8KKwlpZiAoQ09ORklHKGZsYWdzKSAmIENURF9TWU5DX0ZURlcpCisJCXJl
dHVybjsKKwogCXJlc3luY19yZXEoKTsKIH0K

--------------G1DkcpEu02H00sW6kC1EwBQZ--

