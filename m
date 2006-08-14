From: Massimiliano Hofer <max@nucleus.it>
Subject: new ABI
Date: Mon, 14 Aug 2006 23:12:41 +0200
Message-ID: <200608142312.41851.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,
I couldn't keep pace during the day with all the mail that has been written, 
so let me summarize what has been said.
Please forgive (and correct) me if I forget anything.

First of all several people think that the current ABI has shortcomings and 
something has to be done.

Regarding my proposal for priv_data (I'm obviously biased here, but I'll try 
to be objective):
- it offers the ability to store data out of reach to the userspace utilities 
(for whatever housekeeping any match/targets needs);
- it can't offer persistent data to matches/targets.

<biased>
With this patch we can part with some really ugly tricks involving userspace 
structure fields and kernel pointers and it would let us have O(1) matches 
for quota, limit and any other match/target that needs cross match data.
</biased>

People may expect the second feature too, but it's just not possible with the 
current infrastructure. The same infrastructure, making extensive use of 
arrays whose size is determined before we call any module hook function, 
leaves us in the cold for a really flexible solution for other problems too.
I've not yet read all the code involved, but, if we really need to, we may be 
able to use a compat-like interface to maintain ABI compatibility with a new 
netfilter core.

What people need from any new infrastructure:
- cleaner interface with clearer separation between kernel and user data;
- ability to dump internal state of matches/targets (this may not be in a 
1-to-1 relation, so it may be tricky, do we need module state dumping?);
- ability to change chains/rules/matches without reinitializing everything;
- ability to change matches' state or configuration without reinitializing 
everything;
- general infrastructure for common logic that is currently reinvented every 
time (negation comes to mind, but I'm sure there are other things).

<biased>
Regarding user influence over state, especially where the number of states 
doesn't match the number of matches involved, I'm not totally opposed to a 
file-like way of exposing it. I agree that /proc is in a sorry state, but 
configfs is there precisely for this purpose. Of course not everything can be 
done this way and I wouldn't like to have complex data passed and parsed this 
way.
We may need a new set of commands in iptables (should I call it iptables-ng?) 
just for keeping this kind of data (realms, quota groups, conditions, etc.). 
If we had a general way to keep collections of configurations, I'll be glad 
to conform and use it.
</biased>

I think the current array oriented data structures won't allow us to add these 
features. RCU lists come to mind. It sure is a step back in performance 
(sparser access to memory and more memory fragmentation), but it may not be 
that noticeable.
I think every match/target should expode:
- init;
- destroy;
- change;
- dump;
- restore.

Depending on the API change, dump and restore may melt in a single function.

The kernel should let any match:
- receive user supplied initialization data (mostly a rule definition) state 
dumps (this calls for very careful planning and checking);
- send state dumps to userspace;
- keep private data for every match/target;
- keep collections of configurations common to matches in a module (every 
module may keep it without netfilter core help, but if it becomes part of the 
infrastructure it may be handled through the userspace ABI).


Am I forgetting anything?
Do you think any of these features are bugs?
Am I overseeing fatal difficulties related to what I wrote?
Please reply with your opinions. I'll wear my asbestos suite for the next 
couple of days. :)

-- 
Saluti,
   Massimiliano Hofer
