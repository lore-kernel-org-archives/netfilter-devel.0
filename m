From: Pablo Neira <pablo@eurodev.net>
Subject: Re: sparc64 match module - bug id 94
Date: Thu, 06 May 2004 16:39:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409A4E2C.1060907@eurodev.net>
References: <20040505065402.GA18440@hamachi.radom.org> <409A4BBB.9080401@eurodev.net> <Pine.LNX.4.58.0405061546210.24101@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.58.0405061546210.24101@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Chris,

Chris Wilson wrote:

>>Please, if I'm missing something, kill me softly. Is there anything 
>>wrong in fixing up the problem with the following patch?
>>    
>>
>
>Yes, unfortunately. The rate limit is supposed to be per-rule, not global. 
>If you do this then you can't really use more than one limit rule 
>in your ruleset, or you will get very unpredictable results (and very 
>different from the current behaviour).
>  
>

Oh, sure, I missed that. It's not so easy to fix up.

thanks!
Pablo
