From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Wed, 3 Jul 2002 16:45:56 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020703144556.GE956@eychenne.org>
References: <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu> <200207032041.49134.fabrice@celestix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Harald Welte <laforge@gnumonks.org>,
	netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Fabrice MARIE <fabrice@celestix.com>
Content-Disposition: inline
In-Reply-To: <200207032041.49134.fabrice@celestix.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jul 03, 2002 at 08:41:48PM +0800, Fabrice MARIE wrote:

> On Wednesday 03 July 2002 19:24, Jozsef Kadlecsik wrote:

 Hi,

> I believe it's very natural to want to perform several things if a condition
> match, just like you would do in C a
> if (condition1) {
>    action1();
>    action2();
>    action3();
> }
> instead of a
> if (condition1)
>    action1();
> if (condition1)
>    action2();
> if (condition1)
>    action3();

That's what user-defined chains are for.  I agree it is not very
elegant to create a chain for every action group, but there are
generally no plenty of these.

 RV

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
