From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Thu, 31 Oct 2002 20:34:49 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DC1DA39.7040501@videotron.ca>
References: <3DBED94E.1030107@videotron.ca>
 <200210292243.07631.aef@prismnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: allen <aef@prismnet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

allen wrote:

>On Tuesday 29 October 2002 12:54 pm, Stephane Ouellette wrote:
>  
>
>>   I developped last week a new extension to Netfilter in order to
>>enable or disable a set of rules using /proc files.
>>    
>>
>
>
>Yeah, as others have said, the idea is definitely cool.
>
>I hate to admit that I might use it this way.  God help me...
>
>I'm having visions of debugging impossibly complex
>booboo's, and chasing after phantom problems that
>appear and disappear and not remembering that
>I or someone had done or could have done this.
>
>Can you think of a way to implement far greater
>"manageability"
>
>?
>

   I'm not sure to understand your question...   :-(

>
>Or what are your thoughts about that ?
>
>Maybe it is a "user-be-ware" thing best left to
>some odd application to keep track of.
>
>Hmn...
>
>But... the "rules" would appear though... right ?
>
>With an "iptables -L" ?
>  
>

   The rules appear with "iptables -L"  such as :

0   0   ACCEPT      udp    ---    *    *     0.0.0.0/0   0.0.0.0/0   
 condition quake udp dpt:27960

>And current "state" ?
>

   No, the current state is only available if you read the /proc file.

>-AEF
>
>  
>
