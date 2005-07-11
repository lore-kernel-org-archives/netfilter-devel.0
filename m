From: Amin Azez <azez@ufomechanic.net>
Subject: Re: a new version of iptabes
Date: Mon, 11 Jul 2005 15:30:25 +0100
Message-ID: <42D28281.8080505@ufomechanic.net>
References: <464293e605040500395fa1fe55@mail.gmail.com>	<464293e60504050045720b8e52@mail.gmail.com>	<464293e60504070104d1a3029@mail.gmail.com>	<4254F592.6030703@eurodev.net>	<464293e6050409005573f2c7fb@mail.gmail.com>	<939523513.20050409105616@dns.toxicfilms.tv>	<464293e6050413113723cfd4da@mail.gmail.com>
	<464293e605070507066ed3efb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <464293e605070507066ed3efb3@mail.gmail.com>
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

I am inetersted in what you have done but haven't yet had time to look
at it in detail.

Guessing at why you have not had much response:

I see that it may be difficult to supply smaller patches to move over to
your code a bit at a time, but it would be harder for people familiar
with current iptables to change everything in one go to something they
are not familiar with.

You work looks like it would bring impressive benefits to the kernel, so
I make these suggestions and I hope some other more experienced
developers could comment;

To ease adoption of your work, break it into smaller patches which
provide the new features independantly.

Perhaps the first useful feature would be linked lists instead of
continuous memory, and has the direct benefit of reducing startup time
for systems with a lot of rules. This is a distinct benefit.

Next, and as people will then be familiar with your work, introduce more
patches which add different classifiers etc.

As goes with many other patches, you may have to keep them up to date
with newer kernels as people adopt them in their own time.

I have to do the same with my link-layer stuff in conntrack which it
looks like will eventually get replaced with some cross-marking between
iptables, ebtables and arptables.

I think your work is useful and beneficial and encourage you to present
it as seperate patches and to add them to pom-ng if you can (I will
discuss how to do this if you need it). Once it is in pom-ng, or at
least available as a set of up-to-date patches it becomes easier for
other people to try it out.

I certainly am interested in your work and intend to make use of it and
give feedback.

I am currently using kernel 2.6.11 and 2.6.12 with iptables 1.3.1

Earlier versions are too old, are you able to re-work you patches for
later kernels and in 2 parts as suggested?

Amin

hamid jafarian wrote:
> On 4/13/05, hamid jafarian <hamid.jafarian@gmail.com> wrote: 
> 
>>
>>
>>On 4/9/05, Maciej Soltysiak <solt@dns.toxicfilms.tv> wrote: 
>>
>>>Hello hamid,
>>>
>>>Saturday, April 9, 2005, 9:55:50 AM, you wrote:
>>>
>>>
>>>>On Apr 7, 2005 1:25 PM, Pablo Neira < pablo@eurodev.net> wrote:
>>>>
>>>>>cool, where's your version ?
>>>
>>>>if you want .. i will give you the files and also installation help 
>>>
>>>.... but
>>>
>>>>to whom and also how 
>>>
>>>make a website with the patch and installation
>>>
>>>--
>>>Regards,
>>>Maciej
>>
>> hello ...
>>
>>go here ..
>>http://www.geocities.com/hamidreza_jm/
>>
>>-- 
>>H.T. 
> 
> 
> 
> 
> hello again ........ Sir Netfilter developers ...
>  after two month .. if you could use from the new version ... reply to me 
> your ideas about it ..
>  or not please delete it from you computer ..
>  tanks .. 
> 
