From: Chris Lowth <chris@lowth.com>
Subject: Pre-Alpha-test version of "ROPE" match module is now available
Date: Wed, 17 Nov 2004 01:18:15 +0000 (GMT)
Message-ID: <Pine.LNX.4.44.0411170106270.29713-100000@stirling.lowth.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

I mentioned this a little while back, and have finally got round to 
putting the first cut of the code up for download and review.

ROPE is a scripting language that is "compiled" in user-land and executed 
in kernel-land for use as an Iptables match rule. It allows very quick 
development of Iptables match rules for complex criteria, and could even 
be used to "prototype" modules that would later be re-written in C once 
the logic has been proved.

It's brand spanking new, so it's probably full of bugs at the moment, but 
I'd welcome any feedback anyone can give (thanks to those who responded to 
my earlier mail with comments).

Scripts can also be run using a user-land tool to allow development and 
testing outside the kernel.

Documentation is about 90% complete and is growing daily.

Download, build instructions, full reference and tutorial are all 
available at the project's home page:

	http://www.lowth.com/rope

Here's a simple example script that matches an HTTP download with a 
content-length greater than 1000000 bytes...

	$tcp_source 80 eq assert             # from port 80?
	expecti_to( "Content-Length: " )     # find the header
	expect_while({isdigit}) put($n)      # get the value
	if( gt( atoi($n) 1000000 ) { yes } ) # match if too big
	no                                   # otherwise - no match

There is an explanation of this logic in the "Basics" page on the web 
site, along with a more complete version of the same script that also 
handles partial HTTP transfers (etc).

Currently, this is for linux kernel 2.4.x only. I will start work on a 
2.6.x port soon.

Chris
