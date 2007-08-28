From: Dennis Koslowski <mail@dennis-koslowski.de>
Subject: Re: Searching a home for psd
Date: Tue, 28 Aug 2007 16:08:27 +0200
Message-ID: <46D42C5B.20408@dennis-koslowski.de>
References: <44DCCFFD.2080807@rtij.nl>
	<44DD21CF.3090404@trash.net>	<1155409675.2447.4.camel@murdegern.cbxnet.de>
	<44DE34C5.9020604@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Torsten Luettgert <t.luettgert@pressestimmen.de>,
	netfilter-devel@lists.netfilter.org
To: Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44DE34C5.9020604@rtij.nl>
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

Hello,

what ist the current status of the psd patch? Does someone maintain it
or maybe provide a home for it?

Thanks

Martijn Lievaart wrote:
> Torsten Luettgert wrote:
> 
>> On Sat, 2006-08-12 at 02:33 +0200, Patrick McHardy wrote:
>>  
>>
>>> Martijn Lievaart wrote:
>>>   
>>>> Psd has been dropped from patch-o-matic and no one has taken it up. If
>>>> someone can send me the latest pom entries for psd, I'll set up an
>>>> external repository for it. Besides trying to bring it up to date to 
>>>> the
>>>> latest kernel, who knows, maybe I'll really maintain it. Seriously, 
>>>> it's
>>>> a great patch and I would hat to see it go.
>>>>     
>>> Trying to employ all my SVN skills to get a copy didn't help, so please
>>> just grab it from the latest release, there haven't been any changes
>>> since then anyway.
>>>
>>>   
>>
>> "The great removal" occured at 6597 and 6598, so this should work:
>>
>> svn co -r 6596 http://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng
>>
>>  
>>
> 
> Snarfed. Thx.
> 
> M4
> 

-- 
Dennis Koslowski OSS Consulting
Otto-Lilienthal-Straße 36, D-71034 Böblingen
Tel: +49-7031-714-5560, Fax: +49-7031-714-5579
www.dennis-koslowski.de
