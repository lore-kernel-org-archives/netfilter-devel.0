From: Bernd Zeimetz <bernd@zeimetz.de>
Subject: moe infos...
Date: Tue, 15 Nov 2005 01:39:50 +0100
Message-ID: <200511150139.51688.bernd@zeimetz.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 327007@bugs.debian.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

I've run into this bug today, which is allready listed as 327007 on 
bugs.debian.org

0 think:~# iptables -N 123456789012345678901234567
0 think:~# iptables -A FORWARD -j 123456789012345678901234567
0 think:~# iptables -N 1234567890123456789012345678
0 think:~# iptables -A FORWARD -j 1234567890123456789012345678
0 think:~# iptables -N 12345678901234567890123456789
0 think:~# iptables -A FORWARD -j 12345678901234567890123456789
0 think:~# iptables -N 12345678901234567890abcdefg
0 think:~# iptables -A FORWARD -j 12345678901234567890abcdefg
0 think:~# iptables -N 12345678901234567890abcdefgh
0 think:~# iptables -A FORWARD -j 12345678901234567890abcdefgh
0 think:~# iptables -N 12345678901234567890abcdefghi
0 think:~# iptables -A FORWARD -j 12345678901234567890abcdefghi
0 think:~# iptables -N 12345678901234567890abcdefghij
0 think:~# iptables -A FORWARD -j 12345678901234567890abcdefghij
1 think:~# iptables -N 1234567890123456789zabcdefghij
0 think:~# iptables -A FORWARD -j 1234567890123456789zabcdefghij
iptables: No chain/target/match by that name
0 think:~# iptables -N abcde678901234567890abcdefghij
0 think:~# iptables -A FORWARD -j abcde678901234567890abcdefghij
iptables: No chain/target/match by that name
1 think:~# iptables -N abcdesdasdasdfafasfaabcdefghij
0 think:~# iptables -A FORWARD -j abcdesdasdasdfafasfaabcdefghij
iptables: No chain/target/match by that name
1 think:~# iptables -N 0bcdesdasdasdfafasfaabcdefghij
0 think:~# iptables -A FORWARD -j 0bcdesdasdasdfafasfaabcdefghij
iptables: No chain/target/match by that name
1 think:~# iptables -N 0bcdesdasdasdfafasfaabcdefghi
0 think:~# iptables -A FORWARD -j 0bcdesdasdasdfafasfaabcdefghi
iptables: No chain/target/match by that name
1 think:~# iptables -N 0bcdesdasdasdfafasfaabcdefgh
0 think:~# iptables -A FORWARD -j 0bcdesdasdasdfafasfaabcdefgh


As you can see the bug does not happen for chains
- with a length <=28
- with a name containing only numbers
- with a name beginning with numbers and having less than ~11 letters at the 
end.

The interesting part comes now:

iptables -N 123456789012345678yzabcdefgh
and this works:
iptables -A FORWARD -j 123456789012345678yzabcdefghij

The bug takes place during the call of
set_revision(target->t->u.user.name, target->revision); // iptables.c:2397

(which is in the part starting with
              /* If they didn't specify a target, or it's a chain
                   name, use standard. */
                if (!target
                    && (strlen(jumpto) == 0
                        || iptc_is_chain(jumpto, *handle))) 
-- just to make sure you'll find the right one)


Obviously the problem  is in this function:
static void set_revision(char *name, u_int8_t revision)
{
        /* Old kernel sources don't have ".revision" field,
           but we stole a byte from name. */
        name[IPT_FUNCTION_MAXNAMELEN - 2] = '\0';
        name[IPT_FUNCTION_MAXNAMELEN - 1] = revision;
}

As a workaround a return 0; on top of set_revision works, but I'm not sure if 
this opens other bugs because I have no clue what this function is (was!?) 
for - and to speak the truth - I'm too lazy to work myself trough the whole 
code to understand what it does ;)

Hope somebody can fix that :)


Best regards!


Bernd Zeimetz
