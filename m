From: =?big5?q?tin=20man=20chan?= <chantinman40@yahoo.com.hk>
Subject: Problem in using iplimit
Date: Wed, 9 Oct 2002 17:25:15 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021009092515.23022.qmail@web13101.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-1657750136-1034155515=:22438"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
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

--0-1657750136-1034155515=:22438
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: 8bit


Hi,

I have compiled a linux kernel 2.4.19 with iptables-1.2.7a and patch-o-matic-20020825

When I tried the following command which is an example of iplimit.patch:

iptables -p tcp --syn --dport 23 -m iplimit --iplimit-above 2 -j REJECT

and the program warn me:

iptables v1.2.7a: no command specified
Try `iptables -h' or 'iptables --help' for more information.

Can anyone help me? Thanks.

Regards,

Steven Chan

乞丐王子，細路，好心分手，跅跅步哈姆太郎...
越800首至新至Hit手機鈴聲!
Over 800 latest ringtones, only on Yahoo!

--0-1657750136-1034155515=:22438
Content-Type: text/html; charset=big5
Content-Transfer-Encoding: 8bit

<P>Hi,</P>
<P>I have compiled a linux kernel 2.4.19 with iptables-1.2.7a and patch-o-matic-20020825</P>
<P>When I tried the following command which is an example of iplimit.patch:</P>
<P>iptables -p tcp --syn --dport 23 -m iplimit --iplimit-above 2 -j REJECT</P>
<P>and the&nbsp;program warn me:</P>
<P>iptables v1.2.7a: no command specified<BR>Try `iptables -h' or 'iptables --help' for more information.</P>
<P>Can anyone help me? Thanks.</P>
<P>Regards,</P>
<P>Steven Chan</P><p><a href="http://hk.yahoo.com/mail_tagline/?http://hk.ringtone.yahoo.com/ringtone/listsongs?cat=001003">乞丐王子</a>，<a href="http://hk.yahoo.com/mail_tagline/?http://hk.ringtone.yahoo.com/ringtone/listsongs?cat=001001">細路</a>，<a href="http://hk.yahoo.com/mail_tagline/?http://hk.ringtone.yahoo.com/ringtone/listsongs?cat=002009">好心分手</a>，<a href="http://hk.yahoo.com/mail_tagline/?http://hk.ringtone.yahoo.com/ringtone/listsongs?cat=003001">跅跅步哈姆太郎</a>...<br>
<B><a href="http://hk.yahoo.com/mail_tagline/?http://hk.ringtone.yahoo.com/">越800首至新至Hit手機鈴聲!
</a><br>
<a href="http://hk.yahoo.com/mail_tagline/?http://hk.ringtone.yahoo.com/">Over 800 latest ringtones, only on Yahoo!</a></B><br>
--0-1657750136-1034155515=:22438--
