From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: patch for iptables
Date: Tue, 26 Sep 2006 01:25:20 +0200
Message-ID: <45186560.30106@netfilter.org>
References: <200608221634.13559.max@nucleus.it>
	<44EB1A5E.9050304@netfilter.org>
	<200609251756.32814.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200609251756.32814.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Tuesday 22 August 2006 4:53 pm, Pablo Neira Ayuso wrote:
> 
>> The official policy is "do not break backward" :). IHMO, if we want to
>> go further with iptables we need to think about providing a netlink API.
>>
>> For out-of-tree stuff the thing can be different, I have seen breakages
>> if it really required it. For example, the string match is not
>> compatible with the old and broken match for 2.4.
> 
> I'd like to make it backward compatible, but, so far, I've seen only these 
> possibilities:
> a) put a legacy include in the kernel part (ugly);
> b) put a kernel version #ifdef in the userspace part (invasive of the build 
> system, since, as far as I can tell, no such #defines are present);
> c) drop support (it's... well... unsupportive :)).
> 
> Of course you could add "d) you're boneheaded and there's a great solution, 
> it's just that you can't find it". :)
> 
> To be frank, I'm not a great fan of userspace build systems that meddle too 
> much in the kernel,

Nor me but this is something that we have to live with. I think we all
have learnt the lesson: the new netlink libraries for queue, log,
conntrack don't share whole structures between kernel and userspace, so
we don't need to get fixed to a certain layout.

> especially if it's just a few structures and you're 
> committed to keep backward compatibility anyway. It would be more convinient 
> if, for example, I could build iptables with lots of extension I don't have 
> in my kernel. It would be even more convenient if I tried to package an RPM 
> and I didn't want to depend on specific kernel patches being installed.

I understand your situation but breaking backward compatibility is not
the solution. About the possibility of including the version support, I
proposed the revision thing for matches/targets time ago and I must
confess that I don't like it so much: it was a hack, we need it for
popular revisions of multiport and mark but we decided that people might
have really good reasons to add a new version. So, introducing another
revision thing is not something that I like.

> Anyway, I'd tend to discard a) and would like not to choose c).
> Would you accept a patch that introduces kernel version #defines?
> Do you have better solutions?

To implement a netlink interface for iptables.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
