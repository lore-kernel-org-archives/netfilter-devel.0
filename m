From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Fri, 21 Jun 2002 09:47:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206210940180.30045-100000@blackhole.kfki.hu>
References: <20020620145619.GA1404@mail.nontoxic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Laurence J. Lane" <ljlane@nontoxic.org>
In-Reply-To: <20020620145619.GA1404@mail.nontoxic.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Jun 2002, Laurence J. Lane wrote:

> The problem deals with user-defined chain names clashing with iptables
> module names. Basically, it's entirely possible to create a user-defined
> chain with the same name (case sensitive)  as a target module, but the
> new chain cannot be used as a jump target.

We've already seen proposals to solve the problem, but please, we must
maintain as much backward compatibility as possible. Every syntactical
(and semantical) change results only confusion.

The built-in chain and target names are all fully capitalized.
What about the simple restriction that user-defined chain name cannot be a
string consisting of capitalized letters only.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
