From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH] [connlimit] connlimit-above early loop termination
Date: Sun, 13 Feb 2011 13:53:17 -0500
Message-ID: <4D58289D.5000801@linux.vnet.ibm.com>
References: <1297441335.25407.9.camel@d941e-10> <4D556B45.8030304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D556B45.8030304@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 02/11/2011 12:00 PM, Patrick McHardy wrote:
> On 11.02.2011 17:22, Stefan Berger wrote:
>> The patch below introduces an early termination of the loop that is
>> counting matches. It terminates once the counter has exceeded the
>> threshold provided by the user. There's no point in continuing the loop
>> afterwards and looking at other entries.
>>
>> It plays together with the following code further below:
>>
>> return (connections>  info->limit) ^ info->inverse;
>>
>> where connections is the result of the counted connection, which in turn
>> is the matches variable in the loop. So once
>>
>>          ->  matches = info->limit + 1
>> alias   ->  matches>  info->limit
>> alias   ->  matches>  threshold
>>
>> we can terminate the loop.
>>
> Applied, thanks Stefan.
I am currently creating a derivative of this module for a slightly 
different purpose. While testing that one and not using the -m state 
--state -NEW in front of the -m connlimit, I saw that that shortcut 
doesn't work properly but keeps on adding entries into the list. So, 
unfortunately I have to withdraw that patch. I apologize and I'll send a 
patch for this.

   Regards,
      Stefan
