From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack-tools compilation problem
Date: Mon, 06 Aug 2007 10:34:57 +0200
Message-ID: <46B6DD31.5090409@netfilter.org>
References: <20070805153015.GA27598@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: 'Krisztian Kovacs' <hidden@sch.bme.hu>
To: Netfilter Development Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070805153015.GA27598@sch.bme.hu>
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

KOVACS Krisztian wrote:
> I've just tried to build conntrack-tools and all the required netfilter
> libraries from scratch. The libs were built and installed without
> problems, but then conntrack-tools failed to compile with a missing
> include problem.
> 
> Looks like conntrack-tools' autoconf/automake templates do not properly
> use pkg-config information. configure.in detects the presence of
> libnfnetlink and libnetfilter_conntrack using pkg-config, but then fails
> to add the necessary flags to the compile and linker flags. For me, this
> is a problem because all those libraries live under /opt/netfilter, and
> thus compilation fails because of missing headers.
> 
> The attached patch fixes this problem for me, although I'm quite sure that
> it does not break compilation for someone else. (Should not, but I'm not
> much of an autoconf expert...)

Applied, thanks Krisztian!

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.
