From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Security: Add iptables security table for mandatory
 access control rules
Date: Thu, 22 May 2008 14:15:48 +0200
Message-ID: <483563F4.7080408@trash.net>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au> <Xine.LNX.4.64.0805220017511.3033@us.intercode.com.au> <48345A3C.1080407@trash.net> <Xine.LNX.4.64.0805220843571.8393@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <Xine.LNX.4.64.0805220843571.8393@us.intercode.com.au>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

James Morris wrote:
> On Wed, 21 May 2008, Patrick McHardy wrote:
>
>   
>> Applied, thanks. I'll add the dependency myself in case you agree.
>>     
>
> Ok, I can't really see a use for the table without CONFIG_SECURITY, so 
> please go ahead.
>   

Done, thanks.
