From: Munteanu Eduard Gabriel <maxdamage@aladin.ro>
Subject: Re: Multiple targets for REDIRECT & friends
Date: Tue, 23 Aug 2005 02:41:18 +0000
Message-ID: <430A8CCE.5030808@aladin.ro>
References: <43088446.6000303@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <43088446.6000303@aladin.ro>
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

Well, it seems I haven't checked out iptables package thoroughly enough 
before posting here. There is libiptc/linux_list.h which looks like an 
API-compatible userspace implementation of double-linked lists in kernel.

Having this thing answered by myself, I'm asking you the following 
question: should I use these double-linked lists or avoid complexity by 
coming up with some "homemade" single-linked lists? It just needs a 
*next pointer, as I said, so it should be a less complex mechanism. 
Either way, I'll start working on one of these ideas (most probably the 
2nd, since I think it's the right thing to do), since switching to 
another flavour of linked lists is no problem.

Hope to hear from you guys soon,
Eduard Munteanu

P.S.: sorry for posting twice the last message. At first, I didn't want 
to subscribe to the list, so after sending it, I have seen that the 
archives (despite the fact they were enough up-to-date) did not contain 
my post. So I subscribed to the mailing list and sent it again, which 
made my 2nd post go in the archive pretty fast.
