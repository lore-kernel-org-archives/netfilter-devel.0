From: "Mateusz Pluta" <mateusz@republika.pl>
Subject: RE: connlimit patch crashes 2.6.11 kernel
Date: Tue, 17 May 2005 22:33:53 +0200
Message-ID: <20050517203253Z4930396-6071+430@kps6.test.onet.pl>
References: <428A4DEB.8010803@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Patrick McHardy'" <kaber@trash.net>
In-Reply-To: <428A4DEB.8010803@trash.net>
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

Patrick McHardy wrote:
> Mateusz wrote:
>> Problem does not occur when I don't apply connlimit patch to
kernel.
>> 
>> [<c0318777>] imq_nf_queue+0xc7/0x1a0
> 
> Does the problem occur without the imq patch?
> 
> Regards
> Patrick

Yes, I use imq patch, and in crash time packets problably go
through 
the imq device, because I use it to traffic shaping.

One other person found my post, and report me the same problem.

Best regards, Mateusz Pluta
