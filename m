From: Javier Valencia <jvalencia@log01.org>
Subject: Re: unable to reinject the IP packets using ipq_set_verdict (libipq
 API)
Date: Mon, 20 Dec 2004 12:35:31 +0000
Message-ID: <41C6C713.8090703@log01.org>
References: <4EE0CBA31942E547B99B3D4BFAB34811258EA4@mail.esn.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4EE0CBA31942E547B99B3D4BFAB34811258EA4@mail.esn.co.in>
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

Are calculating checksums? If a checksum is invalid, no packet will be 
accepted.
