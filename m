From: "Russ Fink" <russfink@hotmail.com>
Subject: Re: QUEUEing packets to userspace problem
Date: Thu, 28 Apr 2005 14:46:52 -0400
Message-ID: <BAY101-F16608A0B30EA0523698529C2230@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

I'm replying to a very old libipq post dealing with 'Unknown error' because 
I found one possible cause and wanted to post it.  Here's the initial query:

--- From: Maarten Wijnants  maarten.wijnants@pandora.be ---
Hello all,

I'm very new at Linux and especially Linux programming. I apologize if =
this turns out to be a stupid question :-)

When I try the libipq example in the man page, I do not receive any =
packets in my userspace application. I have loaded the iptable_filter =
and ip_queue modules, and I added the following rule to iptables:

iptables -A OUTPUT -p icmp -j QUEUE

Then i hit the "Execute Program" button of my KDeveloper (see below for =
the full code). This way, locally created ping packets should be =
delivered to this application right? But immediately after running the =
code, i get the following error message:=20

Received error message 1
Unknown error
ERROR

and packets do not start comming in in the application when I ping =
another PC. Here's my code: <snip>

---------

My problem was I had a stalled instance of the process already running, and 
was trying to kick off another copy of it.  Apparently, it returned "error 
16 Unknown error" because of this stalled prior process.  When I killed the 
stalled process and tried again, it worked perfectly.  (Next time, I'll use 
-9 on the kill and check to make sure it's dead.)

Russ
