From: Null Device <nulldevice83@yahoo.com>
Subject: help wanted regarding connction limits.
Date: Tue, 27 Apr 2004 14:20:07 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040427212007.42770.qmail@web41908.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi List,

If u recall my previous post i posted regarding
limiting no. of connections per IP per sec on
particular port.

As suggested i got connlimit extension by Gerd Knorr &
Martin Bene.

List with due regards i am very new netfilter
devlment.

Well, i went thought netfilter kernel hacking howto
and other how to's regarding netfilter extensions and
related material.

Well my module is totally netfilter based. NO Ip
Tables. 

The module connlimit registers with iptables 
ipt_register_match(&connlimit_match);

well he prob is i am unable to make out how can i
integrate this code in mine own module.

I went through netfilter-hacking howto title
"Connection Tarcking Helper Module", I tried
ip_conntrack_helper_register(&modified_connlimit) in
my module.

But then i realized, connlimit depends on usual
parametesr which are supposed to be passed to the
matching function when i registers with
ip_register_match ie ptr to skbuff, in and out
devices, ptr to header, and ptr to match info.
And i was lost in the dark how can make it work.

My module is netfilter based. And as a part of it
(along with other functionality that i am
implementing) i want to restrict the no of connections
too. but i am struck here on how to integrate this
code to make the things work for me....to b more
specific abt my project....it resgister two hooks
NF_IP_PRE_ROUTING && NF_IP_POST_ROUTING and does some
checks on every packet (stateless implimentation). I
am to integrate connlimit in this module itself.

any help this regarding would be of extereme help.
thx in advance.


	
		
__________________________________
Do you Yahoo!?
Win a $20,000 Career Makeover at Yahoo! HotJobs  
http://hotjobs.sweepstakes.yahoo.com/careermakeover 
