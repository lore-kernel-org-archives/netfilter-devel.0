From: Deti Fliegl <deti@fliegl.de>
Subject: Re: Can i have a rate limit per source IP Address in IPSet?
Date: Thu, 05 Oct 2006 12:13:12 +0200
Message-ID: <4524DAB8.9000409@fliegl.de>
References: <b322db070610050006v73e69354t8d0106f2eec51597@mail.gmail.com>	
	<4524B968.303@fliegl.de>	
	<b322db070610050243s3a1d65cfqd4cf0ff35abab96e@mail.gmail.com>	
	<4524D64C.4070203@fliegl.de>
	<b322db070610050306r60bcb242i132b58ec70c0bc3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Retesh Chadha <retesh.chadha@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <b322db070610050306r60bcb242i132b58ec70c0bc3d@mail.gmail.com>
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

Retesh Chadha wrote:
> But this page doesnt contain what should be kept in the foo file. I
> dont have  a sample of the same as well..
Oh well..... for example if you set '--hashlimit-name foo' a 
corresponding '/proc/net/ipt_hashlimit/foo' file will be created 
automatically with the first hashlimit match rule in your ruleset. These 
files are not writable and normally there should be no need to look into 
these files except you are a very experienced user.

Deti
