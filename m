From: Chris Lowth <chris@lowth.com>
Subject: POMNG patch: "rope" - scriptable match module
Date: Mon, 12 Dec 2005 23:50:11 +0000
Message-ID: <439E0CB3.1020202@lowth.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I'd like to submit the "rope" match module to the team for consideration 
for inclusion in patch-o-matic-ng.

The patch file is 248k (7511 lines) - so I havent attached it to this 
message, but it can be downloaded from
http://www.lowth.com/rope/PomNgPatch

"rope" provides a kernel-level interpreter for a simple scripting 
language which can be used to develop netfilter match modules. The 
language is pre-compiled using a perl script, to produce a binary file 
that is loaded into the kernel using the "iptables" command. The 
language has access to many IP, TCP and UDP packet headers and the data 
payload. It was originally developed for use as a P2P protocol 
identification mechanism, but has wound up being general enough for 
wider use.

Current limitations..
    Works with version 2.4.x kernels - version 2.6 support is coming.
    Doesnt work with SMP kernels - that too is coming.

The website www.lowth.com/rope includes a number of sample scripts, 
language documentation and tutorials - etc.

Chris
