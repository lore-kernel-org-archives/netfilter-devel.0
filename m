From: Patrick Schaaf <bof@bof.de>
Subject: Re: Table duplication on smp machine
Date: Mon, 31 Mar 2003 15:51:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331135119.GE1098@oknodo.bof.de>
References: <3E881DD6.8090206@hipac.org> <20030331110709.GE7718@sunbeam.de.gnumonks.org> <3E882F52.1040705@hipac.org> <20030331123326.GO7718@sunbeam.de.gnumonks.org> <20030331125610.GC1098@oknodo.bof.de> <3E8843DD.8060501@hipac.org> <20030331134504.GD1098@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Heinz <creatix@hipac.org>, Harald Welte <laforge@netfilter.org>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030331134504.GD1098@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > Very interesting. I guess one has to use a special API to address the
> > per cpu memory so that the current implementation wouldn't work out
> > of the box. Right?
> 
> I assume that the existing per-cpu API in Linux 2.5.xxx will suffice
> to do the right thing on NUMA boxen. It's just a question of carefully
> selecting what physical pages each per-cpu slab is put into. The problem
> can and should be solved in generic allocators.

Now I understand your question :)

Regarding the current implementation, the whole of table memory
is allocated in one vmalloc() call, and that will very likely
NOT do the right thing WRT numa placing. I am pretty sure that
Rusty Russel knows how to get the code there, as he has participated
in the percpu development on linux-kernel.

best regards
  Patrick
