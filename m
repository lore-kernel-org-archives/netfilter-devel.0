From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: RE: conntrack clarification
Date: Tue, 7 Aug 2007 18:08:01 +1000
Message-ID: <4618641.2011186474076639.JavaMail.root@localhost>
References: <29656818.1521186459222779.JavaMail.root@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <29656818.1521186459222779.JavaMail.root@localhost>
Content-Language: en-au
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

> I'm sorry if I'm missing something plainly obvious here, but the case
> in
> point doesn't make sense unless there is some locking function that
> reinserts the state back into the table BEFORE the flush has a chance
> to
> commit the removal.
> 

Please disregard my last mail. I now realize that it is the return TCP
traffic that is keeping the conntrack populated.

Regards,



"Blue Reef disclaimer: This electronic message transmission contains information that is confidential or privileged. The information is intended to be for the use of the individual or entity named above. If you are not the intended recipient, be aware that any disclosure, copying, distribution, or use of the contents of this information is prohibited. If you have received this transmission in error, please notify us by telephone immediately."

Scanned by Sonar. 
Date: 2007-08-07 18:07:56
From: temp02@bluereef.com.au
To: netfilter-devel@lists.netfilter.org
Mail id: challenge-64740762800
