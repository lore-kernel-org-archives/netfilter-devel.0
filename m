From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Table duplication on smp machine
Date: Mon, 31 Mar 2003 16:06:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E884B79.2070301@hipac.org>
References: <3E881DD6.8090206@hipac.org> <20030331110709.GE7718@sunbeam.de.gnumonks.org> <3E882F52.1040705@hipac.org> <20030331123326.GO7718@sunbeam.de.gnumonks.org> <20030331125610.GC1098@oknodo.bof.de> <3E8843DD.8060501@hipac.org> <20030331134504.GD1098@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick

You wrote:
> Regarding the limit target, not current implementation, but seen
> a bit more abstractly, it is possible to arrange things so each
> CPU has its own copy of a partial token bucket, and refills it
> from locked shared pingponging storage only when it empties.

Indeed a good example. Thank you.


Regards

Thomas
