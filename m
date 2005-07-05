From: Nick Hay <nickjhay@hotmail.com>
Subject: Re: Extending LOG target to display pid
Date: Wed, 06 Jul 2005 11:56:33 +1200
Message-ID: <42CB1E31.1000802@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Tobias DiPasquale wrote:
> On 7/5/05, Nick Hay <nickjhay@hotmail.com> wrote:
> 
>>2. Any ideas on how I can get the pid of a local packet's creator in the
>>log module?  I couldn't find any structures connected to the sk_buff
>>that might contain it, and couldn't think of where the data would
>>originally come from.
> 
> 
> A security framework, with the proper auditing and accounting
> mechanisms in place in the network stack could make this possible (any
> it may already be). But in general, it would be quite a lot of work to
> add the necessary code to the stack to account for the
> sending/receiving PID at the correct stage. Unless you're doing MAC,
> its probably not worth it.

My original intention was to replicate some part of Windows' ZoneAlarm
package: the ability to recognise which program was asking for access,
and to filter based on that.  Noticing a strange packet that was blocked
by my filter on outgoing ports, and not being able to find out where it
came from was the immediate motivation :)

Is it better to try this at the SELinux level,
blocking/monitoring/adjusting access to socket creation/use?

>>Actually... would current->pid work?
> 
> No, because there's no guarantee that the same process is on the CPU
> by the time the packet hits your rule.
>
> Can't check on #1 right now, but I believe that its filled in by the
> module itself in whatever way it chooses.

-- Nick
