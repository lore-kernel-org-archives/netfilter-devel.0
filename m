From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Memory Leaks in the iptc libs
Date: 19 Jun 2003 07:13:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1055999618.3200.100.camel@tux.rsn.bth.se>
References: <5.2.0.9.0.20030618212603.00a813e8@wheresmymailserver.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@westboro.org
In-Reply-To: <5.2.0.9.0.20030618212603.00a813e8@wheresmymailserver.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-06-19 at 03:48, netfilter@westboro.org wrote:
> I have written a program - loosely based on iptables that maintains rules 
> under RedHat 9.0.  I am seeing a memory leak - presumably in the kernel and 
> am looking to see if anyone can point me in the right direction.  I can run 
> 67,000 iterations of the program and my memory space is not increasing - 
> but the overall memory usage of the machine seams to have gone up 60-70 
> megabytes.  IE even after I kill my process the memory is up.  For this 
> test I was not increasing the number of rules but deleting one then adding 
> one. This program is meant to be a long running daemon but if the 
> underlying libs leak leak memory that is not part of my process I have issues.

Have you tried the cvs version?

-- 
/Martin
