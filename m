From: Patrick McHardy <kaber@trash.net>
Subject: Re: unregister_netdevice with negative refcnt error while using
 NFQUEUE with ebtables mark
Date: Tue, 27 Mar 2007 17:16:33 +0200
Message-ID: <46093551.2060906@trash.net>
References: <74ECB30468A30A4DA2BD88DA5387CAE3508835@fempexch.FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jay Manni <JManni@FireEye.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <74ECB30468A30A4DA2BD88DA5387CAE3508835@fempexch.FireEye.com>
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

Jay Manni wrote:
> I am using iptables to queue packets to an NFQUEUE from a tap interface (attached to a VM). It works fine, except that I get an unregister_netdevice error with a negative refcnt, while freeing the tap devices.
> 
>  unregister_netdevice: waiting for tap3 to become free. Usage count = -50
> 
> I noticed some posts about the negative refcnt issue but that was related to appletalk.
> Anybody know whats happening here?


Something very broken obviously, the reference count should never
drop below zero. What kernel version are you running, and what
are you using as queuing backend (ip_queue, nfnetlink_queue)?
Can you also reproduce the problem without queueing?
