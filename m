From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: pom without rebuilding kernel?
Date: Tue, 21 Oct 2003 22:08:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310212157001.7523-100000@filer.marasystems.com>
References: <20031017122425.GB18504@puariko.nirvana>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Axel Thimm <Axel.Thimm@physik.fu-berlin.de>
In-Reply-To: <20031017122425.GB18504@puariko.nirvana>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 17 Oct 2003, Axel Thimm wrote:

> How can I identify those patches? Most of the patching happens in
> net/<protocol>/netfilter and include/linux/netfilter_<protocol>. Are
> those patches safe for building out of the tree (w/o full kernel
> rebuilds)?

Any patch which modifies only files within the netfilter directories 
should be safe building netfilter out of the kernel tree.

On patches which only adds files it is safe to just build that new added 
modules out of the tree.

Patches which modifies files within the netfilter directories requires 
that all netfilter modules which depends on the modified files are 
rebuilt. In case of modified C files this is trivial, but if header files 
are modified a more careful analysis is required to determine which 
netfilter modules are impacted by this header file modification.

> I am already maintaining some kernel module rpms as well as some
> non-modularizable patches to RH kernel on atrpms. I am having requests
> to add some netfilter modules (notably the TARPIT and H323 patches),
> and I was considering of packaging (parts of) pom as drop in kernel
> module replacements or enchancements.

On patches which add nat or conntrack helpers you need to verify that the
size of the conntrack structure is not modified. If it is then basically
every single netfilter module need to be rebuild. If the size of the 
structures remains the same then it is safe to build the new helpers 
without rebuilding the rest.

> Here is what I did to get a working H232 kernel module, is this sane
> (seems to work for these modules at least)? Thanks.
> 
> # Create copies of subparts from the unchanged kernel tree to ./linux
> for x in Makefile Documentation/Configure.help include/linux/netfilter_ipv4 include/linux/netfilter_ipv6 net/ipv4/netfilter net/ipv6/netfilter; do
>   mkdir -p linux/`dirname $x`
>   cp -a %{kernelsrcdir}/$x linux/`dirname $x`
> done

You could just

  rm -rf linux
  cp -rpl %{kernelsrcdir} linux

this quickly makes a linked copy of the tree. patch (and p-o-m) works fine 
with linked source trees.

> # Patch the copy
> KERNEL_DIR=linux ./runme --batch extra/h323-conntrack-nat.patch
> 
> cd linux
> %patch0 -p1 -b .lockhelp
> cd ..
> 
> make -C %{kernelsrcdir} SUBDIRS=`pwd`/linux/net/ipv4/netfilter dep
> make -C %{kernelsrcdir} SUBDIRS=`pwd`/linux/net/ipv4/netfilter modules CONFIG_IP_NF_H323=m CONFIG_IP_NF_NAT_H323=m "CPPFLAGS=-D__KERNEL__ -I`pwd`/linux/include -I\$(HPATH)"
> make -C %{kernelsrcdir} SUBDIRS=`pwd`/linux/net/ipv4/netfilter INSTALL_MOD_PATH=$RPM_BUILD_ROOT MOD_DESTDIR=../netfilter/ipv4/netfilter modules_install CONFIG_IP_NF_H323=m CONFIG_IP_NF_NAT_H323=m

It should be noted that this last step is only safe for installing into a 
secondary directory. Do not attempt this without specifying a secondary 
MOD_DESTDIR.. (it will delete all other modules..)

> Unfortunately the make dep step is writing to the orginal kernel tree,
> but i couldn't find a better solution.

for most (if not all) netfilter patches you do not really need to run
"make dep".

Regards
Henrik
