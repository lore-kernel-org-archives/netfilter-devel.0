From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Packet Fragementation
Date: Wed, 31 Mar 2004 06:04:04 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331140404.16955.qmail@web13907.mail.yahoo.com>
References: <Pine.LNX.4.44.0403311457230.21410-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403311457230.21410-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--- Henrik Nordstrom <hno@marasystems.com> wrote:
> In iptables you have the "raw" table which runs at
> NF_IP_PRI_RAW 
> (-200). If you are writing your own netfilter module
> for the 
> mangling/demangle then any priority -399 to -201
> will place your module 
> between defragmentation and connection tracking.

You are the god!!!! TY so much :)
Actually, NF_IP_PRI_RAW is -300 (at least 2.4.25
kernel patch) , so I am golden.
I should be able to register at raw/PREROUTING and get
defragmented packets, fixing them prior to session
establishment. 

> Then in NF_IP_POST_ROUTING there is two conntrack
> hooks running at the
> very last prioritites, one which confirms sessions
> (makes the conntrack
> "official"), immediately followed by the
> refragmenter. The first is not
> involved in connection tracking as such, it only
> confirms the session
> related to the packet in connection tracking as a
> valid session.
Ah good.  So it sounds like I can add in my packet
altering code in mangle/POST_ROUTING (where I have
unfragmented packets ready to head out) and then my
packet de-altering code in raw/PRE_ROUTING (where I
will have de-fragmented packets that have not yet been
examined for session/conn track yet) and I will be a
Happy Camper.

I have a related question, but will make a new post
since it is OT from this thread.  Thanks again!!!!

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
