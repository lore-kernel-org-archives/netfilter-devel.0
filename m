From: Kiran Kumar <immidi_kiran@yahoo.com>
Subject: Re: Help writing netfilter match
Date: Mon, 29 Mar 2004 19:59:08 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040330035908.46877.qmail@web14001.mail.yahoo.com>
References: <406E0129@minerva.ex.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Richard Bishop <R.J.Bishop@exeter.ac.uk>,
  netfilter-devel@lists.netfilter.org
In-Reply-To: <406E0129@minerva.ex.ac.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--- Richard Bishop <R.J.Bishop@exeter.ac.uk> wrote:
> 
> This is compiled with the command  "gcc -shared -o
> libipt_net.so
> -DIPTABLES_VERSION=\"1.2.9\"
> -I/usr/src/linux/include libipt_net.c"  and the
> .so file placed in /lib/iptables. Incidentally I'm
> compiling and running on
> Debian with kernel 2.4.24-1-k7.

  Why dont you use the existing Makefiles for "make"
and "make install"? They would put the proper
libraries in the proper places.

> 
> As root I then run "iptables -A INPUT -m net --help"
> and get "iptables v1.2.9:
> Couldn't load match `net'". I've obviously missed
> something somewhere - can
> somebody point me in the right direction please?! 

  The iptables binary looks for the shared library in
the directory IPT_LIB_DIR (look for it in iptables.c).
So, iptables would be looking for libipt_net.so in
this directory. Making the .so available at the proper
location will solve the problem.

=====
Regards,
Kiran Kumar Immidi

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
