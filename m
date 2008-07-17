From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Security: Add iptables security table for mandatory
 access control rules
Date: Thu, 17 Jul 2008 10:25:33 +0200
Message-ID: <487F01FD.9050609@trash.net>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au> <Xine.LNX.4.64.0805220017511.3033@us.intercode.com.au> <48345A3C.1080407@trash.net> <Xine.LNX.4.64.0805220843571.8393@us.intercode.com.au> <Xine.LNX.4.64.0807171340360.17859@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <Xine.LNX.4.64.0807171340360.17859@us.intercode.com.au>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

James Morris wrote:
> On Thu, 22 May 2008, James Morris wrote:
> 
>> On Wed, 21 May 2008, Patrick McHardy wrote:
>>
>>> Applied, thanks. I'll add the dependency myself in case you agree.
>> Ok, I can't really see a use for the table without CONFIG_SECURITY, so 
>> please go ahead.
> 
> Patrick,
> 
> Do you intend to push this into 2.6.27 ?
> 
> (It would be appreciated).


Its currently in net-next-2.6.git, afaik Dave intends to send a
pull request this Sunday.
