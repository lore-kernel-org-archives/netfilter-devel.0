From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: failed loading SNAT and DNAT library
Date: Thu, 16 Jan 2003 20:12:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030116201252.A9728@linux.karinthy.hu>
References: <20030114141102.14779.87181.Mailman@kashyyyk> <20030114184457.A25511@protei.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: nickolay@protei.ru
Content-Disposition: inline
In-Reply-To: <20030114184457.A25511@protei.ru>; from nickolay@protei.ru on Tue, Jan 14, 2003 at 06:44:57PM +0300
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 14, 2003 at 06:44:57PM +0300, nickolay@protei.ru wrote:
> Hi Guys!
> 
> I'm newbe to developing netfilter code and i have some troubles 
> with it. I need to working with SNAT and DNAT target rules in my 
> new project, but when i trying load shared librarys libipt_SNAT.so 
> for SNAT or libipt_DNAT.so for DNAT targets with dlopen(), program
> executing is stopped on dlopen() call with next error:
> /usr/local/lib/iptables/libipt_SNAT.so: undefined symbol: dotted_to_addr.
> Compile step:
> cc iptest.c -ldl -liptc -o myprog

Basically, you would have to export symbols from the main program (myprog)
so that the modules to be loaded can resolve symbols from the libiptc.a

Check out iptables makefiles. There's an extra -rdynamic argument to cc,
which will in turn add -export-dynamic to ld:

       -export-dynamic
              When  creating  an ELF file, add all symbols to the
              dynamic symbol table.  Normally, the dynamic symbol
              table contains only symbols which are used by a dy-
              namic object.  This option is needed for some  uses
              of dlopen.

This should do it for you.

Laszlo
