From: George Vieira <GeorgeV@citadelcomputer.com.au>
Subject: iptables -L %table% <with rule matching>
Date: Tue, 28 Jan 2003 11:22:28 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200FAA488DE0D41194F10010B597610D5BEAFB@jupiter.citadelcomputer.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I've gone through the source code for iptables 1.2.7a and found it's quite
possible to change it a little to make the -L command list 1 rule instead of
the whole table by using part of the "-D" routines and change it to LIST and
not DELETE, but I'm not a very good linux C programmer.

Is there anyone who could help be achieve this function and make a patch, or
tell me if there is a way to look up a rules byte count without having to
"grep" through the "-L"ist and this takes up valuable CPU when searching
many rules..

I'm trying to write graphing scripts, but on every swoop it chews heaps of
CPU coz' it has to sweep through and grep on every rule it's checking (which
I have around 20-30 rules so far).... 

I hope I made myself clear, and I hope it's possible.. ;)
 
 
Thanks,
____________________________________________
George Vieira
Systems Manager
georgev@citadelcomputer.com.au 
Citadel Computer Systems Pty Ltd
Phone : +61 2 9955 2644
HelpDesk: +61 2 9955 2698  
http://www.citadelcomputer.com.au
 
