From: Peter Christensen <pch@coolsystems.dk>
Subject: Re: Statefull SOCKS filter
Date: Thu, 09 Mar 2006 14:45:30 +0100
Message-ID: <4410317A.3070502@coolsystems.dk>
References: <44101CA5.3070004@coolsystems.dk>
	<Pine.NEB.4.62.0603091307110.29872@norge.freeshell.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexey Toptygin <alexeyt@freeshell.org>
In-Reply-To: <Pine.NEB.4.62.0603091307110.29872@norge.freeshell.org>
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

AFAIK libipq is about having filters in user space which really isn't my 
issue. I have no problem writing kernel modules, and moving stuff into 
user space will only make more overhead without actually adding anything 
useful.
What I am searching for is some solution so that I will not have to keep 
track of all undergoing connections manually. I imagine that this is 
already done somewhere in iptables, and if so I find it waste of time to 
do it again, and spend time creating hash tables etc. etc.
As I pointed out, there aren't really much CPU power. Actually, the 
perfect solution was to write my own OS to the bridge, since I can then 
minimize useless overhead all around, but this will without doubt take 
significantly more time than just writing modules for iptables in linux.
Claims are that netfilter have stateful packet filtering, which I 
interpret as an interface which makes it easy to create state machines 
on IPv4 TCP connections, but I probably have misinterpreted the idear of 
"stateful packet filtering". I imagine a callback such as this (simplified):


int stateful_callback (netfilter_conn_t *conn) {
   switch (conn->state) {
     case STATE_1:
       if (foo)
         conn->state = STATE_2;
       else
         conn->state = STATE_2;
       break;

     case STATE_2:
       // Stuff
   ...
   }
   return (conn->state == STATE_n ? NF_DROP : NF_ACCEPT);
}



--
Best regards

Peter Christensen

Developer
------------------
Cool Systems ApS

Tel: +45 2888 1600
  @ : pch@coolsystems.dk
www: www.coolsystems.dk


Alexey Toptygin wrote:
> 
> Perhaps libipq and the QUEUE target will do what you want?
> 
>             Alexey
