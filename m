From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: pom without rebuilding kernel?
Date: Sat, 11 Oct 2003 22:14:54 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310112210540.14382-100000@filer.marasystems.com>
References: <20031010134525.GB7985@puariko.nirvana>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Axel Thimm <Axel.Thimm@physik.fu-berlin.de>
In-Reply-To: <20031010134525.GB7985@puariko.nirvana>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 10 Oct 2003, Axel Thimm wrote:

> I am thinking how nice it would be (or already is?) to build only the
> required kernel modules for a given kernel, without having to rebuild
> the kernel itself, like a lot of kernel drivers do (e.g. bttv, lirc,
> lm_sensors etc).

Yes, and that you can do.. just patch the kernel sources and run "make 
modules", or extract the sources and compile the modules manually.

> E.g. are there changes in pom patches to the core of the kernel
> sources, or can pom modules be compiled out of the kernel tree?

If you extract the module sources from the pom patches you can in most
cases compile the modules out of the kernel tree if you like, assuming you
have the correct kernel headers in place for the exact kernel binary you
are using (this is a rather tricky part when trying to compile modules to
a distro binary kernel)

There is not really any difference between compiling netfilter kernel 
modules and other kinds of kernel modules, only the packaging is slightly 
different (patch files to the kernel tree rather than separate source 
files, but the patch command can extract the files for you)

Regards
Henrik
