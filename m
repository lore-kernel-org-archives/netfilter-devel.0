From: Eric Leblond <eric@inl.fr>
Subject: Re: Libipq sequence doubt
Date: Tue, 26 Oct 2004 11:17:56 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098782278.3512.26.camel@coati>
References: <20041025234729.GA3141@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
In-Reply-To: <20041025234729.GA3141@maluco.com.br>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2004-10-25 at 19:47 -0400, Ulysses Almeida wrote:
>   I have a doubt about packets sequence, on libipq.
>   Other libipq question, can I mark packets on userspace?

Yes but you need to patch your kernel for that : use ip_queue_vwmark
patch from patch-o-matic
http://www.netfilter.org/patch-o-matic/pom-extra.html#pom-extra-ip_queue_vwmark

BR,
-- 
Eric Leblond <eric@inl.fr>
INL
