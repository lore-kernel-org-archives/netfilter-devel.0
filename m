From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Fri, 21 Jun 2002 10:26:52 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206211022360.30045-100000@blackhole.kfki.hu>
References: <20020621101055.E5183@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Laurence J. Lane" <ljlane@nontoxic.org>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020621101055.E5183@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Jun 2002, Patrick Schaaf wrote:

> > The built-in chain and target names are all fully capitalized.
> > What about the simple restriction that user-defined chain name cannot be a
> > string consisting of capitalized letters only.
>
> This is again breaking backwards compatibility. For example, most of my
> rulesets contain two chains, named "RD" and "LRD". The first does the
> "REJECT with limit, then DROP" stance, and the second puts a "LOG with
> limit" in front of that. As both chains are "designed" to be used with
> the same ease as REJECT or DROP, the "ALL CAPS" naming makes eminent
> sense to me.

Yes, it'd break backward compatibility as well. I see the reasoning for
all capitals in user defined chains as well.

What about simply returning by an error code if there is an attempt to
create a chain wich clashes with a target name?

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
