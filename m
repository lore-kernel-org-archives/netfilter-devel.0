From: Chris Lowth <chris@lowth.com>
Subject: Linux 2.6 support for "rope" match module
Date: Tue, 03 Jan 2006 11:15:23 +0000
Message-ID: <43BA5CCB.6050207@lowth.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Following on from my message to this list of a month or so ago.. "rope" 
now works on linux 2.6 as well as 2.4. As yet SMP is not supported, but 
that is the next thing on my "to do" list, and should surface within a 
couple of months (time permitting).

Please feel free to download, play, comment / critique.

"rope" provides a kernel-level interpreter for a simple scripting 
language which can be used to develop netfilter match modules. The 
language is pre-compiled using a perl script, to produce a binary file 
that is loaded into the kernel using the "iptables" command. The 
language has access to many IP, TCP and UDP packet headers and the data 
payload. It was originally developed for use as a P2P protocol 
identification mechanism, but has wound up being general enough for 
wider use.

It's too large to supply here as a patch, but it can be downloaded from 
http://www.lowth.com/rope/Download. The "Makefile" that comes with the 
software allows rope to patched into POMNG, or directly into the kernel 
and iptables.

As before .. the website www.lowth.com/rope includes a number of sample 
scripts, language documentation and tutorials - etc.
