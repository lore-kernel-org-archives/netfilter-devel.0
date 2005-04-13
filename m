From: Patrick Schaaf <bof@bof.de>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 11:25:19 +0200
Message-ID: <20050413092519.GA22865@oknodo.bof.de>
References: <20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
	<20050413085911.030C.LARK@linux.net.cn>
	<20050413065248.GB16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
	<20050413071427.GC16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504130930060.10437@blackhole.kfki.hu>
	<20050413075251.GD16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504131013550.10437@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0504131013550.10437@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> > Maybe using a generate-C/compile-C approach would become more feasible
> > when both tcc (www.tinycc.org) and gcc are used.
> 
> It seems I'm not on the track: what code would be generated in C?

Roughly, translate each chain into a C function, each table into a C
source file. Load the resulting object like you would load kernel
modules.

Some "standard" matches could be generated inline. Other, more complex
match functions, could be called like before. Maybe some of them would
be marked "const", to tell the compiler that calling them with exactly
the same arguments, will produce exactly the same results.

The compiler could then optimize all redundant checks within a chain
(C function), and an advanced compiler could even do whole-table
optimizations on the table's C source module.

(See, I can wave my hands some more :)

best regards
  Patrick
