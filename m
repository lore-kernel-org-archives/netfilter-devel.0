From: KC Turner <kctst6@pitt.edu>
Subject: Netfilter profiling
Date: Tue, 05 Nov 2002 19:08:35 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.1.6.0.20021105190403.00aecdf8@imap.pitt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello, I am a student studying computer engineering at the University of 
Pittsburgh in Pittsburgh, Pennsylvania USA.   I have been tasked with 
profiling how the Netfilter firewall operates, i.e. in which modules does 
it spend most of its time.  I plan on using a software profiling suite, 
such as VPROF to do this work.  However, I must add code to call the VPROF 
software (to turn it on) in each Netfilter module, but I am having problems 
locating the actual source code that Netfilter uses.  Can anyone tell me 
which files (c files presumably) Netfilter compiles into its executable?  I 
appreciate any help I can get on this, and if anyone has any previous 
information on Netfilter profiling.  Thank you.

--Kasey Turner
   kctst6@pitt.edu
