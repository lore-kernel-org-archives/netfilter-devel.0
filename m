From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Mon, 24 Jun 2002 14:38:34 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206241437170.1998-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.33.0206211347370.30045-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>,
	"Laurence J. Lane" <ljlane@nontoxic.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <Pine.LNX.4.33.0206211347370.30045-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Jun 2002, Jozsef Kadlecsik wrote:

> On Fri, 21 Jun 2002, Patrick Schaaf wrote:
>
> > > What about simply returning by an error code if there is an attempt to
> > > create a chain wich clashes with a target name?
>
> Here is the patch according to my proposal:

I have committed the patch in cvs.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
