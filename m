From: Ozgur AKAN <akan@aiqa.com>
Subject: Re: target, match and checkentry functions
Date: Wed, 28 Apr 2004 16:41:59 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408FB4A7.2070101@aiqa.com>
References: <408F7388.5010704@aiqa.com> <408FAA24.9070707@aiqa.com> <200404281500.49188.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <200404281500.49188.thomas.jarosch@intra2net.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


>libipt4tc.c defines LABEL_ACCEPT as IPTC_LABEL_ACCEPT
>if I'm not mistaken. IPTC_LABEL_ACCEPT is defined in libiptc.h
>
>Thomas
>
>  
>
yes you are completely right!

IPTC_LABEL_ACCEPT is defined as "ACCEPT". That was what I was looking for.

(my brain does not work well when glucose level decreses :) )

thanks,

-- 
Ozgur Akan
