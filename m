From: patric <pakar@imperialnet.org>
Subject: Re: Patch for geoip to make it work with Linux kernel 2.6.22.x
Date: Thu, 12 Jul 2007 01:35:00 +0200
Message-ID: <46956924.7000702@imperialnet.org>
References: <twig.1177771162.67234@bugmachine.ca>	<006801c7c309$2b8532a0$010210ac@BJERKESET.COM>	<Pine.LNX.4.64.0707101839320.11053@fbirervta.pbzchgretzou.qr>	<469415BF.8080805@imperialnet.org>	<Pine.LNX.4.64.0707111938480.11053@fbirervta.pbzchgretzou.qr>
	<469530AE.2030409@imperialnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469530AE.2030409@imperialnet.org>
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

Or... just did some research on this, and there is a possibility for 
multiple queues...


----------------------------------------------------

NFQUEUE target

The NFQUEUE target is used much the same way as the QUEUE target, and is 
basically an extension of it. The NFQUEUE target allows for sending 
packets for separate and specific queues. The queue is identified by a 
16-bit id.

This target requires the nfnetlink_queue kernel support to run. For more 
information on what you can do with the NFQUEUE target, see the QUEUE 
target.

Table 11-12. NFQUEUE target options
Option    --queue-num
Example    iptables -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE 
--queue-num 30
Explanation    The --queue-num option specifies which queue to use and 
to send the queue'd data to. If this option is skipped, the default 
queue 0 is used. The queue number is a 16 bit unsigned integer, which 
means it can take any value between 0 and 65535. The default 0 queue is 
also used by the QUEUE target.

* Works under Linux kernel 2.6.14 and later.
---------------------------------------------------

So i think it's time to update the kernel and do some mods on my code :)


/Patric




patric wrote:

> Yea, that's true as far as i know too.... And that's one con with this...
>
>
> /Patric
>
>
> Jan Engelhardt wrote:
>
>> On Jul 11 2007 01:26, patric wrote:
>>  
>>> Just wanted to repost that there is a userspace daemon for this too..
>>>
>>> http://bladerunner.mine.nu/CJ/
>>>
>>> So if there is a bug in the code only the daemon fails and not the 
>>> entire
>>> kernel.. =)
>>>
>>> It also eliminates the issues with kernel-revision incompatibility 
>>> and should
>>> make  it easier for people to setup.
>>>     
>>
>> As far as I know you can only have one NFQUEUE userspace program at a 
>> time.
>>
>>  
>>> Have not really had any time lately to
>>> work anything on this, but current release seems to be stable and 
>>> has a current
>>> uptime of around a month (my last reboot of that system).
>>>
>>>
>>> Just don't laugh to much when reading the code... LOTS of really 
>>> ugly code, but
>>> it works..  :)
>>>
>>>     
>>
>>     Jan
>>   
>
>
>
