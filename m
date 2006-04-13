From: varun <varun@rocsys.com>
Subject: Re: iptables doubt
Date: Thu, 13 Apr 2006 18:31:30 +0530
Message-ID: <443E4BAA.3020607@rocsys.com>
References: <443D06A7.1060504@rocsys.com> <443E21C1.9090508@info.ucl.ac.be>
	<443E341F.1080206@rocsys.com> <443E42E6.2010405@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sebastien Tandel <standel@info.ucl.ac.be>
In-Reply-To: <443E42E6.2010405@info.ucl.ac.be>
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

Hi Sebastien,

                           Thanx again. Yeah i cannot set a rule for lo. 
Though it is not necessary in my case i would like have that option. So 
is static rule only the way?
                           Another thing is i want to implement rule 
priority.
                            That is after the rules are set when a 
packet arrives it needs to search the rule chain. I want that to 
searched with respect to priority. So even the user can change the 
priority of already set rule as he likes. Is it already implemented in 
iptables or is it needed to be implemented?

                             I also want to maintain unique rule id. 
That is say i declair unsigned int i;
                             So for any rule be it nat or anything this 
is global rule id that is assigned to any policy added.
                            By this say if a user added a rule whose id 
i give as 15. And then he deletes it then after adding another policy he 
will get policy id of 16 and not 15. rule no 15 will be given only after 
full size of unsigned int is completed, i mean one full circle (i = 0 to 
i=4294967295). So to do it how should i go about it? Any suggestions?

Varun








Sebastien Tandel wrote:

>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>
>varun wrote:
>  
>
>>Hi Sebastien,
>>
>>                           Thanx for the reply. Actually i did figure
>>out some things. It seems to work fine but iam not sure if may lead to
>>any problem. This is what i have done.
>>Instead of adding static routes what i have done is added this small
>>code in the function ipt_do_table.
>>
>>                             if(in == NULL)
>>                  goto jump;
>>         if(memcmp(in->name,"lo",2) == 0)
>>             {
>>                  verdict = NF_ACCEPT;
>>                  return verdict;
>>             }
>>
>>jump:
>>* We handle fragments by dealing with the first fragment as
>>        * if it was a normal packet.  All other fragments are treated
>>        * normally, except that they will NEVER match rules that ask
>>        * things we don't know, ie. tcp syn flag or ports).  If the
>>        * rule is also a fragment-specific rule, non-fragments won't
>>        * match it. */
>>       offset = ntohs(ip->frag_off) & IP_OFFSET;
>>    
>>
>
>It seems "good" modulo these changes to be more concise ...
>
>	if (in != NULL && memcmp(in->name, "lo", 2) == 0)
>		return NF_ACCEPT;
>	 * We handle fragments by dealing with the first fragment as
>         * if it was a normal packet.  All other fragments are treated
>         * normally, except that they will NEVER match rules that ask
>         * things we don't know, ie. tcp syn flag or ports).  If the
>         * rule is also a fragment-specific rule, non-fragments won't
>         * match it. */
>        offset = ntohs(ip->frag_off) & IP_OFFSET;
>
>Note that you have done a shortcut that does not test the outgoing
>interface. It means that you can receive packets from another interface
>and going to the loopback address ...
>
>  
>
>>With this every time a packet comes with IN dev as lo i would simply
>>accept. It seems ok and works well but is there any problem with it if i
>>do so?
>>
>>    
>>
>
>IMHO, there is no pblm doing this way except that :
>	1) you have hardcoded the "rule" (half-hardcoded see remark here above)
>	2) there is no more option to change the behavior of the "rule" you
>just added (i.e. we can't reject anymore a packet going through the
>loopback interface)
>
>
>  
>
>>Varun
>>
>>
>>
>>
>>
>>
>>
>>
>>Sebastien Tandel wrote:
>>
>>Hi,
>>varun wrote:
>> 
>>
>>    
>>
>>>>>Hi all,
>>>>>
>>>>>           Iam new to netfilters and iam trying to play around to
>>>>>understand a few things. By default when no policies are specified then
>>>>>it allows all traffic to go out and in to the n/w. I want to change this
>>>>>to default as deny.
>>>>>           That is when there is no policy all should be default deny.
>>>>>
>>>>>         So in order to achieve that i tried to change the  code a
>>>>>little.
>>>>>          In the file iptable_filter.c there is a variable called
>>>>>static int forward = NF_ACCEPT
>>>>>           I changed this to NF_DROP and when i compiled and used it
>>>>>sure i was not able to send any or recv any packets
>>>>>  
>>>>>          
>>>>>
>>I think you made the right change in your code in order to have a DROP
>>policy by default in your netfilter. the problem is just after ...
>>
>> 
>>
>>    
>>
>>>>>           but even after i give a policy like iptables -t filter -A
>>>>>INPUT -j ACCEPT
>>>>>           Nothing changes. So achieve what i want what should i do?
>>>>>And where do i change?
>>>>>  
>>>>>          
>>>>>
>>It is quiet normal as you told netfilter to accept incoming packets but
>>you did not configure netfilter to accept *outgoing* packets ...
>>iptables -t filter -A OUTPUT -j ACCEPT
>>
>> 
>>
>>    
>>
>>>>>           Another thing is that in normally when i put a policy like
>>>>>iptables -t filter -A OUTPUT -j REJECT
>>>>>            Even my own self IP doesnt ping? Why should this happen?
>>>>>             Isint it ok to ping local ip and loopback ip?
>>>>>              If i want such implementation where i should be able to
>>>>>ping to self and local but not any other ip?
>>>>>              Is it possible?
>>>>>  
>>>>>          
>>>>>
>>lo is the interface allotted to your local interface (i.e. your host)!
>>You must therefore create two rules in order to let netfilter accept
>>outgoing and incoming packets from and arriving to your local interface.
>>iptables -A INPOUT -i lo -j ACCEPT
>>iptables -A OUTPUT -o lo -j ACCEPT
>>
>>
>> 
>>
>>    
>>
>>>>>              I dont want to add policies rather is it possible just by
>>>>>changing the iptables kernel code?
>>>>>  
>>>>>          
>>>>>
>>You have to initialize netfilter by adding two static rules implementing
>>the ones described here above.
>>
>>sta
>>    
>>
>
>  
>
>
>
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.4.2 (GNU/Linux)
>Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org
>
>iD8DBQFEPkLmw76McB8jGxkRAsN0AJ4jZP6mhN2vk+/L93qy5uhC8WSJVwCfQpun
>Fc4d8NMUJo6M64QBMPTO/dg=
>=c7ol
>-----END PGP SIGNATURE-----
>
>  
>
