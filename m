From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: ipt_time module doesn't work
Date: Sat, 2 Dec 2006 13:24:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612021321490.3645@bizon.gios.gov.pl>
References: <45714f16.12e.3c4a.391057889@webmailh2.aruba.it>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-423759253-1165062250=:3645"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Fulvio Ricciardi <fulvio.ricciardi@zeroshell.net>
In-Reply-To: <45714f16.12e.3c4a.391057889@webmailh2.aruba.it>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-423759253-1165062250=:3645
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 2 Dec 2006, Fulvio Ricciardi wrote:

> Hi,
Hello,

> sorry for the cross posting of this message but on other
> mailinglist I never obtain a reply. I think this is the more
> correct place where post the following problem.
Indeed.

> I noticed ipt_time doesn't work with the kernels 2.6.18.2
> and 2.6.19.
> The error messages is the following:
>
> iptables -A INPUT -mtime
> iptables: Unknown error 4294967295
>
> Is it possible to solve the problem? will time extention be
> broken for ever?
>
> Thanks you in advance for  your replies.
> Best Regards

Strange, it _should_ work, and it works for me:

root@fw1:~#  iptables -A INPUT -mtime
root@fw1:~# iptables -L INPUT
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
            0    --  anywhere             anywhere            TIME on all=
=20
days
root@fw1:~# uname -r
2.6.18.1

Where did you get ipt_time from?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-423759253-1165062250=:3645--
