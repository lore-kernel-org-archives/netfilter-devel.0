From: Romp <romp@siil.net>
Subject: Re: problem with iplimit
Date: Sat, 26 Oct 2002 11:26:53 +0300 (EEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.43.0210261122460.1050-100000@nuhkija.sise>
References: <03c501c27ad4$9e5ac740$060110ac@localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <03c501c27ad4$9e5ac740$060110ac@localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The problem appears every time I try to use this module.
> if I set --limit-above to 2 and try to open third connection, system will drop it (ok).
> But if I try to open this connection again (while previous 2 connections are still active), system will accept it (!).
> Since, almost every connection will be accepted (!).
> Note that if I close all connections, and try to make described test again, all will happen again.
>

the problem (and fix) is also described at
http://lists.netfilter.org/pipermail/netfilter-devel/2002-May/007818.html

unfortunately, the patch provided does not solve the problem (at least for
me)

romp
