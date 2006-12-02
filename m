From: "Fulvio Ricciardi" <fulvio.ricciardi@zeroshell.net>
Subject: ipt_time module doesn't work
Date: Sat, 02 Dec 2006 11:01:58 +0100
Message-ID: <45714f16.12e.3c4a.391057889@webmailh2.aruba.it>
Reply-To: fulvio.ricciardi@zeroshell.net
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,
sorry for the cross posting of this message but on other
mailinglist I never obtain a reply. I think this is the more
correct place where post the following problem.
I noticed ipt_time doesn't work with the kernels 2.6.18.2
and 2.6.19.
The error messages is the following:

iptables -A INPUT -mtime
iptables: Unknown error 4294967295

Is it possible to solve the problem? will time extention be
broken for ever?

Thanks you in advance for  your replies.
Best Regards

--------------------------------------------------------------------
Fulvio Ricciardi
web: http://www.zeroshell.net/eng/
skype: zeroshellnet
Phone: +3908321835630
