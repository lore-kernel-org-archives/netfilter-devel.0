From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.22-rc2 built on ppc
Date: Sun, 20 May 2007 19:48:30 +0200
Message-ID: <465089EE.6080406@trash.net>
References: <20070520111809.GG3253@aragorn.home.lxtec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Elimar Riesebieter <riesebie@lxtec.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070520111809.GG3253@aragorn.home.lxtec.de>
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

Elimar Riesebieter wrote:
> FYI, building the kernel with
> gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
> on my powerbook (PPC) gives:
> ...
> ipc/msg.c: In function 'sys_msgctl':
> ipc/msg.c:390: warning: 'setbuf.qbytes' may be used uninitialized in this function
> ipc/msg.c:390: warning: 'setbuf.uid' may be used uninitialized in this function
> ipc/msg.c:390: warning: 'setbuf.gid' may be used uninitialized in this function
> ipc/msg.c:390: warning: 'setbuf.mode' may be used uninitialized in this function
> ipc/sem.c: In function 'sys_semctl':
> ipc/sem.c:861: warning: 'setbuf.uid' may be used uninitialized in this function
> ipc/sem.c:861: warning: 'setbuf.gid' may be used uninitialized in this function
> ipc/sem.c:861: warning: 'setbuf.mode' may be used uninitialized in this function


Probably just another bogus gcc warning. In any case it has nothing
to do with netfilter.
