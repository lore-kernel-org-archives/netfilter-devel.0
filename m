From: "=?ISO-8859-2?Q?Stanis=B3aw_Pitucha?=" <viraptor@gmail.com>
Subject: Re: netfilter queue not on filter table
Date: Tue, 3 Jul 2007 16:14:47 +0100
Message-ID: <717e7cba0707030814h2de28c4fx8b672b518a9c008d@mail.gmail.com>
References: <717e7cba0707030739h48ce146es8a0e67744af3f790@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <717e7cba0707030739h48ce146es8a0e67744af3f790@mail.gmail.com>
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

I made a mistake before:
> - QUEUE target works as expected on filter/INPUT, but I don't catch
> any packets if I try to set it up in nat/PREROUTING or
> mangle/PREROUTING. What can be the cause?
