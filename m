From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: netfilter & ipv6
Date: Tue, 08 Feb 2005 09:50:40 +0200
Message-ID: <42086F50.9090504@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi!

I have found that there seems to be a bunch of match & target modules 
for iptables that don't exist for ip6tables.. Like CLASSIFY for example. 
And some that exist have only a subset of the features.

Also some modules exist only for linux 2.4 but were never ported to 2.6 
or don't compile cleanly anymore on the newest 2.6 kernels.

While I don't have that much experience of 2.6 yet and only have been 
hacking some smaller modules for 2.4 in the past, I think I should have 
enough skills to at least port/update some of these.

So I thought maybe I could help out with this task - ipv6 is something 
that I hope and think will take over ipv4 some day and I'd like for 
linux to be able to provide the same experience then as ipv4 users of 
iptables have today.

I have some questions..

1. Some modules (will) look almost identical on ipv4 on and ipv6 - would 
there be any point in making the ipv4 modules export some symbols and 
then re-use those methods in ipv6 if it wouldn't imply any (major) 
changes to the ipv4 modules?

2. I think it could be nice to keep track of what modules exist for ipv4 
and ipv6 on some web page and maybe also let people sign up to join the 
porting effort (if there are any =). What do you think? And is that 
something I could help out with as well? I have a server at home that 
could run it, however behind an 0,5M adsl line..

3. If I succeed porting something, what should I name the patch to be 
sent to patch-o-matic-ng? I don't think I could just extend the existing 
ones as that would suggest the original authors have something to do 
with it and also some of them also are pending or already included in 
the ekernel. So, would CLASSIFY_v6 be an acceptable name for the ipv6 
version of CLASSIFY? And maybe condition_26 for the 2.6 port of 
condition from 2.4? What's your general procedure if someone have 
updates to a module that someone else did? Should the original authors 
be contacted instead of sending patches to this list?

Any suggestions you have are welcome!

-- 
- xkr47
