From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: Re: REJECT using invalid data
Date: Wed, 8 Dec 2004 08:17:35 +0530
Message-ID: <200412080817.35575.immidi@spymac.com>
References: <20041207010130.GC4757@netnation.com>
	<20041207172823.GA31513@netnation.com>
	<41B62B54.8060003@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>,
 Simon Kirby <sim@netnation.com>
In-Reply-To: <41B62B54.8060003@eurodev.net>
Content-Disposition: inline
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

On Wednesday 08 December 2004 03:44, Pablo Neira wrote:

>Now I see, if state tracking is not enable there's no way to avoid this 
>problem. But I guess that we should drop all malformed packets, not only 
>those which have bad checksums. Would you like to give a try to the 
>patch attached?

  Just a comment on this;

+static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =

  This makes the array about 64 bytes long, would be better to store as an 
array of valid flags rather than as a bit mask;

-- 
Regards,
Kiran Kumar Immidi
