From: Nikolai Malykh <nmalykh@ieee.org>
Subject: tbf match submission
Date: Sat, 05 Feb 2005 22:53:09 +0300
Message-ID: <42052425.8080009@ieee.org>
Reply-To: nmalykh@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hello all,

I would like to submit a new iptables match, developed by BiLiM Systems, 
for inclusion into the main netfilter/iptables tree.

The new match is called "tbf" because it based on the TBF algoritm also 
known as leaky Bucket. My work based on previous match limit, iplimit 
and hashlimit. New match can works like hashlimit (all, srcip, dstip, 
srcport, dstport modes) or like limit (nothing mode). Unlike limit and 
hashlimit this match support inversion for whole iptable rule 
(match/don't match).

New match allow to filter malicious traffic by one iptables line like:

iptables -A INPUT -p tcp -m tcp --dport smtp -m state --state NEW -m tbf 
! --tbf 1/s --tbf-deep 1 --tbf-mode all --tbf-name SMTP 
--tbf-htable-expire 360000 -j DROP

against many concurrent connections to SMTP from open relay (spam) or like:

iptables -A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m tbf ! 
--tbf 1/hour --tbf-deep 2 --tbf-mode all --tbf-name SSH 
--tbf-htable-expire 360000 -j DROP

In nothing mode this match is equivalent to limit match (excluding 
inversion support). You can check them by two rules like

-A INPUT -p udp -m udp --dport 9 -m limit --limit 1/min --limit-burst 3 
-j LOG --log-prefix "LIMIT: "
-A INPUT -p udp -m udp --dport 9 -m tbf --tbf 1/d --tbf-deep 1 
--tbf-name UDP --tbf-htable-expire 100000 --tbf-mode all -j LOG 
--log-prefix "TBF-LIMIT: "

I have tried to get the patch into a format suitable for POM, using
 > Rusty's NEWPATCHES guide.

You can download source code from
[http://www.nmalykh.org/work/tbf.tar.gz].

Any comments are very welcome.

Thank You

-- 
Nikolai Malykh
nmalykh@ieee.org

phone +7 (812) 449 0770
ICQ UIN 30741141
