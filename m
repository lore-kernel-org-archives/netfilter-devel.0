From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Thu, 31 Oct 2002 20:51:59 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DC1DE3F.7040404@videotron.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
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

--- Harald Welte <laforge@gnumonks.org> wrote:

>> On Tue, Oct 29, 2002 at 10:43:07PM -0600, allen wrote:
>  
>
>>> > 
>>> > 
>>> > On Tuesday 29 October 2002 12:54 pm, Stephane Ouellette wrote:
>>    
>>
>>>> > >    I developped last week a new extension to Netfilter in order to
>>>> > > enable or disable a set of rules using /proc files.
>>>      
>>>
>>> > 
>>> > 
>>> > Yeah, as others have said, the idea is definitely cool.
>>    
>>
>> 
>> Though the idea is cool, I think we are solving a problem the wrong way.  Why
>> add complexity to the kernel for a problem which can be solved without
>> any problem from userspace?
>> 
>> Where is the problem in having a couple of different rulesets (e.g. created
>> with iptables-save) which are then loaded using an iptables-restore
>> commandline or a script at the shell of the firewall?
>

Harald,

   I have already tried the solution you propose on a production 
environment and it proved difficult to deal with.  Using the condition 
match, it is far faster to enable/disable rule sets than it is with a 
set of scripts.  It is also less error-prone on a management point of 
view as the firewall rules never change.

I would suggest that the condition match makes it to P-O-M, and let the 
users try it.

Regards,

Stephane Ouellette.
