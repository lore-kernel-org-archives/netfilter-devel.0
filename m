From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: Re: New target
Date: Tue, 14 Feb 2006 19:37:50 -0300
Message-ID: <43F25BBE.4040903@speedy.com.ar>
References: <43F0B0F8.6060909@speedy.com.ar>
	<43F0B596.2010808@cpsc.ucalgary.ca> <43F0CE59.5040201@speedy.com.ar>
	<43F128FB.6040009@cpsc.ucalgary.ca>
	<20060213185128.A78007@tempest.prismnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <20060213185128.A78007@tempest.prismnet.com>
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

Allen Francom wrote:
> 
> 
> Also,
> 
> With IPSec, can you "require" any communication from
> a.com to b.com to be encrypted ?
> 
> IPTables might be able to enforce a requirement for
> encrypted communications.
> 
> Just a thought...
> 
> FYI
> -AEF
> 
> 
> On Mon, 13 Feb 2006, Rennie deGraaf wrote:
> 
> Gervasio Bernal wrote:
> 
>>>> Rennie deGraaf wrote:
>>>>
>>>>> Gervasio Bernal wrote:
>>>>>
>>>>>
>>>>>>> Hi all!!!
>>>>>>>
>>>>>>> I have developed a new target for iptables that encrypts a
>>>>>>> communication. I would like to send it so that you can see it and
>>>>>>> prove
>>>>>>> it. And the possibility that in a future adding it to iptables.
>>>>>>> Which are the steps to follow?
>>>>>>> Thanks a lot!
>>>>>
>>>>>
>>>>>
>>>>> Our of curiosity, what advantages does your method have over IPSec?
>>>>>
>>>>> Rennie
>>>>
>>>>
>>>>
>>>> The great advantage is the ease of use. You only need to put 2 iptables
>>>> rules in each endpoint of communication. One rule for encryption and the
>>>> other for decryption. IPSec is a little more complicated to configure.
> 
> 
> Well, I'd be interested in taking a look at your design.  How about
> posting your design and source somewhere so that we can take a look at
> it?
> 
> Rennie
>>

You are right Allen, that is another interesting difference.
