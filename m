From: Patrick McHardy <kaber@trash.net>
Subject: Re: SYN,URG combination considered INVALID by tcp conntrack
Date: Thu, 07 Sep 2006 17:01:06 +0200
Message-ID: <45003432.4040705@trash.net>
References: <20060906144746.446d813c.m.posthuma@sangine.com>	<44FF118A.3090502@trash.net>
	<20060907090859.d246b66a.m.posthuma@sangine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Posthuma <m.posthuma@sangine.com>
In-Reply-To: <20060907090859.d246b66a.m.posthuma@sangine.com>
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

Martijn Posthuma wrote:
>>>Does someone know of a good reason that this flag combination is excluded?
>>
>>No, I guess it should be considered valid. Out of interest, did the
>>SYN packets actually carry data?
> 
> 
> Not in this case (it turned out to be a non initialized variable). We are hoping to be able to do this in the future to ie speed up the restart of a interrupted ftp-session.

Mhh .. we can certainly change it (I don't see any harm in this), but
I don't think you will have much success with this. Linux for example
will simple ignore the data and wait for the sender to retransmit.
According to this comment solaris will even give you an error:


/* Now we have several options: In theory there is
 * nothing else in the frame. KA9Q has an option to
 * send data with the syn, BSD accepts data with the
 * syn up to the [to be] advertised window and
 * Solaris 2.1 gives you a protocol error. For now
 * we just ignore it, that fits the spec precisely
 * and avoids incompatibilities. It would be nice in
 * future to drop through and process the data.
 *
 * Now that TTCP is starting to be used we ought to
 * queue this data.
 * But, this leaves one open to an easy denial of
 * service attack, and SYN cookies can't defend

 * against this problem. So, we drop the data
 * in the interest of security over speed.
 */
