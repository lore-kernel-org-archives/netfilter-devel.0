From: Robert Scott <rbscott@metavize.com>
Subject: OR with the --set-mark flag
Date: Tue, 03 Aug 2004 15:43:52 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41101528.6080609@metavize.com>
References: <20040803151102.30082.31199.Mailman@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040803151102.30082.31199.Mailman@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

It appears that using the MARK target "--set-mark <value>" option always 
overwrites whatever mark is already there with <value>.  Is there a way 
to perform an OR operation with what is already there?

--rb
