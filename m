From: "Cloud nine" <cloud@cutey.com>
Subject: [new BUG] base ipv4 patch: QUOTA
Date: Thu, 24 Oct 2002 15:05:17 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021024200517.81990.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

<P>Please email me a solution or when the bugs have been identified and also when it is fixed.  Thanks.</P>
<P>BUG:  the quota extension fails.  I have the byte count in iptables set the same as quota during rule creation of the first rule.<BR>BUG:  quota is not set correctly when i use 5368709120 bytes as the quota.</P>
<P># iptables -A FORWARD -c 0 5368709120 -i eth0 -o ppp0 -m quota --quota 5368709120</P>
<P># iptables -A FORWARD -c 0 313524224 -i eth0 -o ppp0 -m quota --quota 1073741824 </P>
<P>---- Byte count in iptables EXCEED quota.  See the following: -------</P>
<P>Chain FORWARD (policy DROP 0 packets, 0 bytes)<BR>    pkts      bytes target     prot opt in     out     source               dest<BR>ination</P>
<P>     889 5368789535 ACCEPT     all  --  eth0   ppp0    anywhere             anywhere           quota: 5368646485 bytes<BR>       0 313524224 ACCEPT     all  --  eth0   ppp0    anywhere             anywhere           quota: 1073741824 bytes</P>
<P> </P>
<P>-------------------------<BR>mail: cloud at cutey dot com</P>
<P>iptables-1.2.6a tar bz2 (patch-o-matic: psd, recent, quota, iplimit)<BR>linux-2.4.7-10 (from RedHat 7.2 - other patches: htb2.4)</P>
-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup
