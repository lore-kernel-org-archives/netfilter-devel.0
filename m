From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Fri, 5 Jul 2002 03:15:30 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705011530.GA3729@aaricia.hemmet.chalmers.se>
References: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com> <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-03 13:24:46+0200, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> ->
>
> Also, no one answered the question yet on how to name an action module
> without breaking the current clear distiction in name between match and
> target modules.
> 

Well I did when I suggested the name/class "action". An action is named with
a capital first and the rest lowercase.

Example.

-m matchexample -a Actionexample -j TARGETEXAMPLE



-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
